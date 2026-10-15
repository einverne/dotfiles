import importlib.util
from pathlib import Path
import tempfile
import unittest
from unittest import mock


SCRIPT = Path(__file__).parents[1] / "scripts" / "analyze-image.py"
SPEC = importlib.util.spec_from_file_location("analyze_image", SCRIPT)
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class AtlasProviderTests(unittest.TestCase):
    def test_build_payload_uses_inline_image_and_atlas_model(self):
        with tempfile.NamedTemporaryFile(suffix='.png') as image:
            image.write(b'png-bytes')
            image.flush()
            payload = MODULE.build_atlas_payload(
                [image.name], 'Describe this image', MODULE.ATLAS_DEFAULT_MODEL
            )

        self.assertEqual(payload['model'], 'google/gemini-3.5-flash')
        content = payload['messages'][0]['content']
        self.assertTrue(content[0]['image_url']['url'].startswith('data:image/png;base64,'))
        self.assertEqual(content[1], {'type': 'text', 'text': 'Describe this image'})

    def test_atlas_inline_rejects_pdf(self):
        with tempfile.NamedTemporaryFile(suffix='.pdf') as document:
            document.write(b'%PDF-1.4')
            document.flush()
            with self.assertRaisesRegex(ValueError, 'PNG, JPEG, and WEBP'):
                MODULE.image_to_data_url(document.name)

    @mock.patch.object(MODULE, 'find_atlas_api_key', return_value='test-key')
    @mock.patch.object(MODULE.urllib.request, 'urlopen')
    def test_atlas_analysis_submits_once(self, urlopen, _find_key):
        response = mock.MagicMock()
        response.__enter__.return_value = response
        response.__exit__.return_value = False
        response.read.side_effect = None
        urlopen.return_value = response

        with mock.patch.object(MODULE.json, 'load', return_value={
            'choices': [{'message': {'content': 'A red alarm clock.'}}]
        }):
            with mock.patch.object(MODULE, 'build_atlas_payload', return_value={
                'model': MODULE.ATLAS_DEFAULT_MODEL,
                'messages': []
            }):
                result = MODULE.analyze_image_atlas(
                    ['clock.png'], 'Describe it', MODULE.ATLAS_DEFAULT_MODEL
                )

        self.assertEqual(result, 'A red alarm clock.')
        urlopen.assert_called_once()


if __name__ == '__main__':
    unittest.main()
