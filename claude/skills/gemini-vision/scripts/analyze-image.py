#!/usr/bin/env python3
"""
Gemini Vision API - Image Analysis Script

This script analyzes images using Google's Gemini API with support for:
- Single or multiple images
- Inline data or File API uploads
- Object detection and segmentation
- Custom prompts and models

API Key Lookup Order:
1. Process environment variable (GEMINI_API_KEY)
2. Skill directory (.claude/skills/gemini-vision/.env)
3. Project directory (.env or .gemini_api_key)
"""

import argparse
import base64
import json
import os
import sys
from pathlib import Path
from typing import List, Optional
import urllib.error
import urllib.request


ATLAS_BASE_URL = "https://api.atlascloud.ai/v1"
ATLAS_DEFAULT_MODEL = "google/gemini-3.5-flash"
GEMINI_DEFAULT_MODEL = "gemini-2.5-flash"

def find_api_key() -> Optional[str]:
    """
    Find GEMINI_API_KEY using 3-step lookup:
    1. Process environment variable
    2. Skill directory (.env)
    3. Project directory (.env or .gemini_api_key)
    """
    # Step 1: Check process environment
    api_key = os.environ.get('GEMINI_API_KEY')
    if api_key:
        return api_key

    # Step 2: Check skill directory
    skill_dir = Path(__file__).parent.parent  # .claude/skills/gemini-vision/
    skill_env = skill_dir / '.env'

    if skill_env.exists():
        with open(skill_env, 'r') as f:
            for line in f:
                line = line.strip()
                if line.startswith('GEMINI_API_KEY='):
                    return line.split('=', 1)[1].strip().strip('"\'')

    # Step 3: Check project directory
    # Try to find project root (go up from skill dir)
    project_dir = skill_dir.parent.parent.parent  # Back to project root

    # Check .env in project root
    project_env = project_dir / '.env'
    if project_env.exists():
        with open(project_env, 'r') as f:
            for line in f:
                line = line.strip()
                if line.startswith('GEMINI_API_KEY='):
                    return line.split('=', 1)[1].strip().strip('"\'')

    # Check .gemini_api_key in project root
    api_key_file = project_dir / '.gemini_api_key'
    if api_key_file.exists():
        with open(api_key_file, 'r') as f:
            return f.read().strip()

    return None


def find_atlas_api_key() -> Optional[str]:
    """Find ATLASCLOUD_API_KEY without accepting it as a CLI argument."""
    api_key = os.environ.get('ATLASCLOUD_API_KEY')
    if api_key:
        return api_key

    skill_dir = Path(__file__).parent.parent
    project_dir = skill_dir.parent.parent.parent
    for env_path in (skill_dir / '.env', project_dir / '.env'):
        if env_path.exists():
            with open(env_path, 'r') as f:
                for line in f:
                    line = line.strip()
                    if line.startswith('ATLASCLOUD_API_KEY='):
                        return line.split('=', 1)[1].strip().strip('"\'')
    return None


def image_to_data_url(path: str) -> str:
    """Load a local or remote image and return an OpenAI-compatible data URL."""
    mime_types = {
        '.png': 'image/png',
        '.jpg': 'image/jpeg',
        '.jpeg': 'image/jpeg',
        '.webp': 'image/webp',
        '.heic': 'image/heic',
        '.heif': 'image/heif',
        '.pdf': 'application/pdf'
    }

    if path.startswith(('http://', 'https://')):
        import requests
        response = requests.get(path, timeout=60)
        response.raise_for_status()
        content_type = response.headers.get('content-type', '').split(';')[0]
        if not content_type or content_type == 'application/octet-stream':
            content_type = mime_types.get(Path(path).suffix.lower(), 'image/jpeg')
        image_bytes = response.content
    else:
        path_obj = Path(path)
        if not path_obj.exists():
            raise FileNotFoundError(f"File not found: {path}")
        content_type = mime_types.get(path_obj.suffix.lower(), 'image/jpeg')
        image_bytes = path_obj.read_bytes()

    if content_type not in {'image/png', 'image/jpeg', 'image/webp'}:
        raise ValueError(
            f"Atlas Cloud inline vision supports PNG, JPEG, and WEBP; got {content_type}."
        )
    if len(image_bytes) > 20 * 1024 * 1024:
        raise ValueError("Atlas Cloud inline images must be 20 MB or smaller.")

    encoded = base64.b64encode(image_bytes).decode('ascii')
    return f"data:{content_type};base64,{encoded}"


def build_atlas_payload(image_paths: List[str], prompt: str, model: str) -> dict:
    content = [
        {
            'type': 'image_url',
            'image_url': {'url': image_to_data_url(path)}
        }
        for path in image_paths
    ]
    content.append({'type': 'text', 'text': prompt})
    return {
        'model': model,
        'messages': [{'role': 'user', 'content': content}]
    }


def analyze_image_atlas(image_paths: List[str], prompt: str, model: str) -> str:
    """Analyze images through Atlas Cloud with one non-retried POST."""
    api_key = find_atlas_api_key()
    if not api_key:
        raise RuntimeError(
            "ATLASCLOUD_API_KEY not found in the environment or an existing .env file."
        )

    payload = build_atlas_payload(image_paths, prompt, model)
    request = urllib.request.Request(
        f"{ATLAS_BASE_URL}/chat/completions",
        data=json.dumps(payload).encode(),
        headers={
            'Authorization': f'Bearer {api_key}',
            'Content-Type': 'application/json',
            'User-Agent': 'gemini-vision-skill/atlas-cloud'
        },
        method='POST'
    )
    try:
        with urllib.request.urlopen(request, timeout=120) as response:
            data = json.load(response)
    except urllib.error.HTTPError as error:
        body = error.read().decode(errors='replace')
        raise RuntimeError(
            f"Atlas Cloud request failed ({error.code}): {body[:400]}"
        ) from error

    try:
        return data['choices'][0]['message']['content']
    except (KeyError, IndexError, TypeError) as error:
        raise RuntimeError(f"Atlas Cloud returned an unexpected response: {data}") from error


def analyze_image(
    image_paths: List[str],
    prompt: str,
    model: str = GEMINI_DEFAULT_MODEL,
    output_format: Optional[str] = None,
    provider: str = "gemini"
) -> str:
    """
    Analyze one or more images with Gemini API.

    Args:
        image_paths: List of image file paths or URLs
        prompt: Question or instruction for the model
        model: Gemini model to use
        output_format: Optional output format (json, markdown, etc.)

    Returns:
        Model response text
    """
    if provider == 'atlas':
        return analyze_image_atlas(image_paths, prompt, model)

    try:
        from google import genai
        from google.genai import types
    except ImportError:
        print("Error: google-genai package not installed.", file=sys.stderr)
        print("Install with: pip install google-genai", file=sys.stderr)
        sys.exit(1)

    # Find API key
    api_key = find_api_key()
    if not api_key:
        print("Error: GEMINI_API_KEY not found.", file=sys.stderr)
        print("Set it using one of these methods:", file=sys.stderr)
        print("  1. export GEMINI_API_KEY='your-key'", file=sys.stderr)
        print("  2. Create .claude/skills/gemini-vision/.env", file=sys.stderr)
        print("  3. Create .env or .gemini_api_key in project root", file=sys.stderr)
        sys.exit(1)

    # Initialize client
    client = genai.Client(api_key=api_key)

    # Prepare content parts
    contents = []

    # Add prompt first if single image (best practice)
    if len(image_paths) == 1:
        contents.append(prompt)

    # Add images
    for path in image_paths:
        if path.startswith('file://'):
            # File API reference
            file_id = path[7:]  # Remove 'file://' prefix
            contents.append(types.File(name=file_id))
        elif path.startswith('http://') or path.startswith('https://'):
            # URL - download and convert to bytes
            import requests
            response = requests.get(path)
            response.raise_for_status()

            # Detect MIME type from content-type header or extension
            content_type = response.headers.get('content-type', '').split(';')[0]
            if not content_type or content_type == 'application/octet-stream':
                # Fallback to extension
                ext = Path(path).suffix.lower()
                mime_types = {
                    '.png': 'image/png',
                    '.jpg': 'image/jpeg',
                    '.jpeg': 'image/jpeg',
                    '.webp': 'image/webp',
                    '.heic': 'image/heic',
                    '.heif': 'image/heif',
                    '.pdf': 'application/pdf'
                }
                content_type = mime_types.get(ext, 'image/jpeg')

            contents.append(types.Part.from_bytes(
                data=response.content,
                mime_type=content_type
            ))
        else:
            # Local file
            path_obj = Path(path)
            if not path_obj.exists():
                print(f"Error: File not found: {path}", file=sys.stderr)
                sys.exit(1)

            # Read file
            with open(path, 'rb') as f:
                image_bytes = f.read()

            # Detect MIME type from extension
            ext = path_obj.suffix.lower()
            mime_types = {
                '.png': 'image/png',
                '.jpg': 'image/jpeg',
                '.jpeg': 'image/jpeg',
                '.webp': 'image/webp',
                '.heic': 'image/heic',
                '.heif': 'image/heif',
                '.pdf': 'application/pdf'
            }
            mime_type = mime_types.get(ext, 'image/jpeg')

            contents.append(types.Part.from_bytes(
                data=image_bytes,
                mime_type=mime_type
            ))

    # Add prompt after images for multi-image (best practice)
    if len(image_paths) > 1:
        contents.append(prompt)

    # Generate response
    try:
        response = client.models.generate_content(
            model=model,
            contents=contents
        )
        return response.text
    except Exception as e:
        print(f"Error calling Gemini API: {e}", file=sys.stderr)
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(
        description='Analyze images using Google Gemini API',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Analyze single image
  %(prog)s image.jpg "What's in this image?"

  # Multiple images
  %(prog)s img1.jpg img2.jpg "What's different?"

  # From URL
  %(prog)s https://example.com/img.jpg "Describe this"

  # Use uploaded file
  %(prog)s file://file-id "Caption this"

  # Specify model
  %(prog)s image.jpg "Detect objects" --model gemini-2.0-flash

  # Request JSON output
  %(prog)s image.jpg "List objects as JSON" --format json
        """
    )

    parser.add_argument(
        'images',
        nargs='+',
        help='Image file paths, URLs, or file:// references'
    )

    parser.add_argument(
        'prompt',
        help='Question or instruction for the model'
    )

    parser.add_argument(
        '--provider',
        choices=['gemini', 'atlas'],
        default='gemini',
        help='Vision provider (default: gemini)'
    )

    parser.add_argument(
        '--model',
        default=None,
        help='Model ID (defaults to gemini-2.5-flash or google/gemini-3.5-flash)'
    )

    parser.add_argument(
        '--format',
        choices=['json', 'markdown', 'plain'],
        help='Preferred output format'
    )

    args = parser.parse_args()

    # Enhance prompt with format request if specified
    prompt = args.prompt
    if args.format:
        format_instructions = {
            'json': ' Return the response as valid JSON.',
            'markdown': ' Return the response as markdown.',
            'plain': ' Return the response as plain text.'
        }
        prompt += format_instructions.get(args.format, '')

    # Analyze images
    result = analyze_image(
        image_paths=args.images,
        prompt=prompt,
        model=args.model or (
            ATLAS_DEFAULT_MODEL if args.provider == 'atlas' else GEMINI_DEFAULT_MODEL
        ),
        output_format=args.format,
        provider=args.provider
    )

    print(result)


if __name__ == '__main__':
    main()
