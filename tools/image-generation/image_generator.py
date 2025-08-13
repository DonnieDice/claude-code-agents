#!/usr/bin/env python3
"""
Ultimate Image Generation Tool for Claude Code
Supports multiple providers with automatic fallback
"""

import os
import sys
import json
import base64
import requests
import urllib.parse
from pathlib import Path
from typing import Optional, Dict, Any
from datetime import datetime
import time

class ImageGenerator:
    """Multi-provider image generation with automatic fallback"""
    
    def __init__(self, config_path: Optional[str] = None):
        self.config = self.load_config(config_path)
        self.providers = {
            'pollinations': self.generate_pollinations,
            'together': self.generate_together,
            'deepai': self.generate_deepai,
            'stability': self.generate_stability,
            'openai': self.generate_openai,
            'replicate': self.generate_replicate,
            'huggingface': self.generate_huggingface,
            'getimg': self.generate_getimg,
            'leonardo': self.generate_leonardo,
            'midjourney': self.generate_midjourney_unofficial
        }
        
    def load_config(self, config_path: Optional[str] = None) -> Dict:
        """Load configuration from file or environment"""
        if config_path and Path(config_path).exists():
            with open(config_path, 'r') as f:
                return json.load(f)
        
        # Default config with environment variables
        return {
            'providers': {
                'pollinations': {'enabled': True, 'priority': 1},
                'together': {
                    'enabled': bool(os.getenv('TOGETHER_API_KEY')),
                    'api_key': os.getenv('TOGETHER_API_KEY'),
                    'priority': 2
                },
                'deepai': {
                    'enabled': bool(os.getenv('DEEPAI_API_KEY')),
                    'api_key': os.getenv('DEEPAI_API_KEY'),
                    'priority': 3
                },
                'stability': {
                    'enabled': bool(os.getenv('STABILITY_API_KEY')),
                    'api_key': os.getenv('STABILITY_API_KEY'),
                    'priority': 4
                },
                'openai': {
                    'enabled': bool(os.getenv('OPENAI_API_KEY')),
                    'api_key': os.getenv('OPENAI_API_KEY'),
                    'priority': 5
                },
                'replicate': {
                    'enabled': bool(os.getenv('REPLICATE_API_TOKEN')),
                    'api_key': os.getenv('REPLICATE_API_TOKEN'),
                    'priority': 6
                },
                'huggingface': {
                    'enabled': bool(os.getenv('HUGGINGFACE_API_KEY')),
                    'api_key': os.getenv('HUGGINGFACE_API_KEY'),
                    'priority': 7
                },
                'getimg': {
                    'enabled': bool(os.getenv('GETIMG_API_KEY')),
                    'api_key': os.getenv('GETIMG_API_KEY'),
                    'priority': 8
                },
                'leonardo': {
                    'enabled': bool(os.getenv('LEONARDO_API_KEY')),
                    'api_key': os.getenv('LEONARDO_API_KEY'),
                    'priority': 9
                }
            },
            'output_dir': './generated_images',
            'default_size': '1024x1024',
            'save_metadata': True
        }
    
    def generate_pollinations(self, prompt: str, **kwargs) -> Optional[str]:
        """Generate using Pollinations.ai (free, no auth)"""
        try:
            size = kwargs.get('size', '1024x1024')
            width, height = size.split('x')
            
            encoded_prompt = urllib.parse.quote(prompt)
            url = f"https://image.pollinations.ai/prompt/{encoded_prompt}"
            url += f"?width={width}&height={height}&nologo=true"
            
            response = requests.get(url, stream=True, timeout=30)
            if response.status_code == 200:
                return response.content
        except Exception as e:
            print(f"Pollinations error: {e}")
        return None
    
    def generate_together(self, prompt: str, **kwargs) -> Optional[str]:
        """Generate using Together AI"""
        if not self.config['providers']['together'].get('api_key'):
            return None
            
        try:
            response = requests.post(
                "https://api.together.xyz/v1/images/generations",
                headers={
                    "Authorization": f"Bearer {self.config['providers']['together']['api_key']}",
                    "Content-Type": "application/json"
                },
                json={
                    "model": "stabilityai/stable-diffusion-xl-base-1.0",
                    "prompt": prompt,
                    "width": 1024,
                    "height": 1024,
                    "steps": 50,
                    "n": 1
                },
                timeout=60
            )
            
            if response.status_code == 200:
                data = response.json()
                # Together returns base64 encoded image
                if data.get('data') and data['data'][0].get('b64_json'):
                    return base64.b64decode(data['data'][0]['b64_json'])
        except Exception as e:
            print(f"Together AI error: {e}")
        return None
    
    def generate_deepai(self, prompt: str, **kwargs) -> Optional[str]:
        """Generate using DeepAI"""
        if not self.config['providers']['deepai'].get('api_key'):
            return None
            
        try:
            response = requests.post(
                "https://api.deepai.org/api/text2img",
                data={'text': prompt},
                headers={'api-key': self.config['providers']['deepai']['api_key']},
                timeout=30
            )
            
            if response.status_code == 200:
                result = response.json()
                if result.get('output_url'):
                    img_response = requests.get(result['output_url'])
                    if img_response.status_code == 200:
                        return img_response.content
        except Exception as e:
            print(f"DeepAI error: {e}")
        return None
    
    def generate_stability(self, prompt: str, **kwargs) -> Optional[str]:
        """Generate using Stability AI"""
        if not self.config['providers']['stability'].get('api_key'):
            return None
            
        try:
            size = kwargs.get('size', '1024x1024')
            width, height = size.split('x')
            
            response = requests.post(
                "https://api.stability.ai/v1/generation/stable-diffusion-xl-1024-v1-0/text-to-image",
                headers={
                    "Authorization": f"Bearer {self.config['providers']['stability']['api_key']}",
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                },
                json={
                    "text_prompts": [{"text": prompt, "weight": 1}],
                    "cfg_scale": 7,
                    "height": int(height),
                    "width": int(width),
                    "samples": 1,
                    "steps": 30
                },
                timeout=60
            )
            
            if response.status_code == 200:
                data = response.json()
                if data.get('artifacts'):
                    return base64.b64decode(data['artifacts'][0]['base64'])
        except Exception as e:
            print(f"Stability AI error: {e}")
        return None
    
    def generate_openai(self, prompt: str, **kwargs) -> Optional[str]:
        """Generate using OpenAI DALL-E"""
        if not self.config['providers']['openai'].get('api_key'):
            return None
            
        try:
            size = kwargs.get('size', '1024x1024')
            
            response = requests.post(
                "https://api.openai.com/v1/images/generations",
                headers={
                    "Authorization": f"Bearer {self.config['providers']['openai']['api_key']}",
                    "Content-Type": "application/json"
                },
                json={
                    "model": "dall-e-3",
                    "prompt": prompt,
                    "n": 1,
                    "size": size,
                    "quality": kwargs.get('quality', 'standard')
                },
                timeout=60
            )
            
            if response.status_code == 200:
                data = response.json()
                if data.get('data'):
                    img_url = data['data'][0]['url']
                    img_response = requests.get(img_url)
                    if img_response.status_code == 200:
                        return img_response.content
        except Exception as e:
            print(f"OpenAI error: {e}")
        return None
    
    def generate_replicate(self, prompt: str, **kwargs) -> Optional[str]:
        """Generate using Replicate"""
        if not self.config['providers']['replicate'].get('api_key'):
            return None
            
        try:
            # Start prediction
            response = requests.post(
                "https://api.replicate.com/v1/predictions",
                headers={
                    "Authorization": f"Token {self.config['providers']['replicate']['api_key']}",
                    "Content-Type": "application/json"
                },
                json={
                    "version": "39ed52f2a78e934b3ba6e2a89f5b1c712de7dfea535525255b1aa35c5565e08b",
                    "input": {
                        "prompt": prompt,
                        "width": 1024,
                        "height": 1024,
                        "num_outputs": 1
                    }
                }
            )
            
            if response.status_code == 201:
                prediction = response.json()
                prediction_id = prediction['id']
                
                # Poll for result
                for _ in range(60):  # Max 60 seconds
                    time.sleep(1)
                    status_response = requests.get(
                        f"https://api.replicate.com/v1/predictions/{prediction_id}",
                        headers={"Authorization": f"Token {self.config['providers']['replicate']['api_key']}"}
                    )
                    
                    if status_response.status_code == 200:
                        result = status_response.json()
                        if result['status'] == 'succeeded':
                            img_url = result['output'][0]
                            img_response = requests.get(img_url)
                            if img_response.status_code == 200:
                                return img_response.content
                        elif result['status'] == 'failed':
                            break
        except Exception as e:
            print(f"Replicate error: {e}")
        return None
    
    def generate_huggingface(self, prompt: str, **kwargs) -> Optional[str]:
        """Generate using HuggingFace"""
        if not self.config['providers']['huggingface'].get('api_key'):
            return None
            
        try:
            model = kwargs.get('model', 'stabilityai/stable-diffusion-xl-base-1.0')
            
            response = requests.post(
                f"https://api-inference.huggingface.co/models/{model}",
                headers={
                    "Authorization": f"Bearer {self.config['providers']['huggingface']['api_key']}",
                    "Content-Type": "application/json"
                },
                json={"inputs": prompt},
                timeout=60
            )
            
            if response.status_code == 200:
                return response.content
        except Exception as e:
            print(f"HuggingFace error: {e}")
        return None
    
    def generate_getimg(self, prompt: str, **kwargs) -> Optional[str]:
        """Generate using GetImg.ai"""
        if not self.config['providers']['getimg'].get('api_key'):
            return None
            
        try:
            response = requests.post(
                "https://api.getimg.ai/v1/stable-diffusion-xl/text-to-image",
                headers={
                    "Authorization": f"Bearer {self.config['providers']['getimg']['api_key']}",
                    "Content-Type": "application/json"
                },
                json={
                    "prompt": prompt,
                    "model": "stable-diffusion-xl-v1-0",
                    "width": 1024,
                    "height": 1024,
                    "steps": 30,
                    "guidance": 7.5,
                    "output_format": "jpeg"
                },
                timeout=60
            )
            
            if response.status_code == 200:
                data = response.json()
                if data.get('image'):
                    return base64.b64decode(data['image'])
        except Exception as e:
            print(f"GetImg error: {e}")
        return None
    
    def generate_leonardo(self, prompt: str, **kwargs) -> Optional[str]:
        """Generate using Leonardo.ai"""
        if not self.config['providers']['leonardo'].get('api_key'):
            return None
            
        try:
            # Create generation
            response = requests.post(
                "https://cloud.leonardo.ai/api/rest/v1/generations",
                headers={
                    "Authorization": f"Bearer {self.config['providers']['leonardo']['api_key']}",
                    "Content-Type": "application/json"
                },
                json={
                    "prompt": prompt,
                    "modelId": "6bef9f1b-29cb-40c7-b9df-32b51c1f67d3",  # Leonardo Diffusion XL
                    "width": 1024,
                    "height": 1024,
                    "num_images": 1
                },
                timeout=60
            )
            
            if response.status_code == 200:
                data = response.json()
                generation_id = data['sdGenerationJob']['generationId']
                
                # Poll for result
                for _ in range(60):
                    time.sleep(2)
                    status_response = requests.get(
                        f"https://cloud.leonardo.ai/api/rest/v1/generations/{generation_id}",
                        headers={"Authorization": f"Bearer {self.config['providers']['leonardo']['api_key']}"}
                    )
                    
                    if status_response.status_code == 200:
                        result = status_response.json()
                        if result['generations_by_pk']['status'] == 'COMPLETE':
                            img_url = result['generations_by_pk']['generated_images'][0]['url']
                            img_response = requests.get(img_url)
                            if img_response.status_code == 200:
                                return img_response.content
                            break
        except Exception as e:
            print(f"Leonardo error: {e}")
        return None
    
    def generate_midjourney_unofficial(self, prompt: str, **kwargs) -> Optional[str]:
        """Placeholder for Midjourney integration (requires Discord bot)"""
        print("Midjourney requires Discord bot integration - not implemented")
        return None
    
    def generate(self, prompt: str, provider: Optional[str] = None, **kwargs) -> Dict[str, Any]:
        """Generate image with automatic fallback"""
        
        # Setup output directory
        output_dir = Path(self.config['output_dir'])
        output_dir.mkdir(parents=True, exist_ok=True)
        
        # Determine providers to try
        if provider and provider in self.providers:
            providers_to_try = [provider]
        else:
            # Sort providers by priority
            enabled_providers = [
                (name, conf) for name, conf in self.config['providers'].items()
                if conf.get('enabled', False)
            ]
            providers_to_try = [
                name for name, _ in sorted(
                    enabled_providers,
                    key=lambda x: x[1].get('priority', 999)
                )
            ]
        
        # Try each provider
        for provider_name in providers_to_try:
            print(f"Trying {provider_name}...")
            
            if provider_name not in self.providers:
                continue
                
            image_data = self.providers[provider_name](prompt, **kwargs)
            
            if image_data:
                # Save image
                timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
                filename = f"{provider_name}_{timestamp}.jpg"
                filepath = output_dir / filename
                
                with open(filepath, 'wb') as f:
                    f.write(image_data)
                
                # Save metadata if enabled
                if self.config.get('save_metadata'):
                    metadata = {
                        'prompt': prompt,
                        'provider': provider_name,
                        'timestamp': timestamp,
                        'size': kwargs.get('size', self.config['default_size']),
                        'filename': filename
                    }
                    
                    metadata_path = filepath.with_suffix('.json')
                    with open(metadata_path, 'w') as f:
                        json.dump(metadata, f, indent=2)
                
                return {
                    'success': True,
                    'provider': provider_name,
                    'filepath': str(filepath),
                    'prompt': prompt
                }
        
        return {
            'success': False,
            'error': 'All providers failed',
            'prompt': prompt
        }

def main():
    """CLI interface"""
    if len(sys.argv) < 2:
        print("Usage: python image_generator.py <prompt> [provider] [size]")
        print("Providers: pollinations, together, deepai, stability, openai, replicate, huggingface, getimg, leonardo")
        print("Example: python image_generator.py 'cyberpunk city' pollinations 1024x1024")
        sys.exit(1)
    
    prompt = sys.argv[1]
    provider = sys.argv[2] if len(sys.argv) > 2 else None
    size = sys.argv[3] if len(sys.argv) > 3 else '1024x1024'
    
    generator = ImageGenerator()
    result = generator.generate(prompt, provider=provider, size=size)
    
    if result['success']:
        print(f"[SUCCESS] Image generated by {result['provider']}")
        print(f"Saved to: {result['filepath']}")
    else:
        print(f"[FAILED] {result['error']}")

if __name__ == "__main__":
    main()