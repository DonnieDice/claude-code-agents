# Image Generation Agent

## Purpose
This agent specializes in AI image generation using multiple providers with automatic fallback. It can create images from text descriptions using various AI models including Stable Diffusion, DALL-E, and free alternatives.

## Capabilities

### Primary Functions
- Generate images from text prompts using 10+ different AI providers
- Automatic fallback between providers if one fails
- Support for multiple image sizes and aspect ratios
- Metadata tracking for all generated images
- Free generation option (no API key required)

### Supported Providers
1. **Pollinations** (FREE) - No authentication required
2. **OpenAI DALL-E 3** - Highest quality, most creative
3. **Stability AI** - Official Stable Diffusion API
4. **Together AI** - Fast SDXL generation
5. **Replicate** - Access to multiple models
6. **HuggingFace** - Open source models
7. **DeepAI** - Affordable generation
8. **GetImg.ai** - Fast and reliable
9. **Leonardo.ai** - Advanced creative control
10. **Midjourney** (planned) - Via Discord integration

## Tool Location
`tools/image-generation/image_generator.py`

## Usage Examples

### Basic Generation (Free)
```bash
python tools/image-generation/image_generator.py "a cyberpunk city at night"
```

### Specific Provider
```bash
python tools/image-generation/image_generator.py "fantasy dragon" stability 1024x1024
```

### With Quality Settings
```bash
python tools/image-generation/image_generator.py "portrait of a robot" openai 1024x1024
```

## Configuration

### Quick Setup
1. Run the setup script:
   ```powershell
   .\tools\image-generation\setup.ps1
   ```

2. (Optional) Add API keys to enable premium providers:
   - Edit `tools/image-generation/.env`
   - Add your API keys for desired providers

### Manual Configuration
Edit `tools/image-generation/config.json`:
- Set `enabled: true` for providers you want to use
- Add API keys for premium providers
- Adjust priority order for automatic fallback
- Configure output directory and metadata settings

## Prompt Engineering Tips

### Best Practices
1. **Be Specific**: Include details about style, lighting, composition
2. **Use Art Terms**: "digital art", "oil painting", "photorealistic"
3. **Specify Quality**: "highly detailed", "4k", "masterpiece"
4. **Include Style**: "in the style of [artist]", "cyberpunk aesthetic"

### Example Prompts
- "A serene Japanese garden in autumn, soft morning light, watercolor style"
- "Futuristic spaceship interior, neon lighting, highly detailed, cinematic"
- "Portrait of a wizard, fantasy art, dramatic lighting, digital painting"

## API Key Sources

### Free Options
- **Pollinations**: No key needed
- **Together AI**: Free tier at together.xyz
- **HuggingFace**: Free tier at huggingface.co

### Paid Options
- **OpenAI**: platform.openai.com ($0.04-0.08 per image)
- **Stability**: platform.stability.ai ($0.002-0.02 per image)
- **Replicate**: replicate.com (pay per generation)
- **GetImg**: getimg.ai (subscription plans)
- **Leonardo**: leonardo.ai (credit-based system)

## Integration with Claude Code

### As a Tool
When Claude Code needs to generate images:
```python
from tools.image_generation.image_generator import ImageGenerator

generator = ImageGenerator()
result = generator.generate("your prompt here")
if result['success']:
    print(f"Image saved to: {result['filepath']}")
```

### Command Line Usage
```bash
# From claude-code-agents directory
python tools/image-generation/image_generator.py "prompt"

# Using the batch file (Windows)
tools\image-generation\generate.bat "prompt"
```

## Troubleshooting

### Common Issues
1. **No image generated**: Check internet connection, API keys
2. **Provider fails**: Will automatically try next provider
3. **Slow generation**: Some providers take 30-60 seconds
4. **Quality issues**: Try different providers or adjust prompts

### Debug Mode
Set environment variable for verbose output:
```bash
set DEBUG=true
python tools/image-generation/image_generator.py "test"
```

## Advanced Features

### Batch Generation
Generate multiple variations:
```python
for i in range(5):
    generator.generate(f"{prompt}, variation {i}")
```

### Custom Models
Some providers support specific models:
```python
generator.generate(prompt, provider='huggingface', 
                  model='runwayml/stable-diffusion-v1-5')
```

### Size Options
- Square: 256x256, 512x512, 1024x1024
- Portrait: 512x768, 1024x1792
- Landscape: 768x512, 1792x1024

## Performance Notes

### Speed Ranking (fastest to slowest)
1. Pollinations (5-10 seconds)
2. Together AI (10-15 seconds)
3. DeepAI (10-20 seconds)
4. GetImg (15-25 seconds)
5. Stability AI (20-30 seconds)
6. HuggingFace (20-40 seconds)
7. OpenAI (30-45 seconds)
8. Replicate (30-60 seconds)
9. Leonardo (45-90 seconds)

### Quality Ranking (best to good)
1. OpenAI DALL-E 3
2. Leonardo.ai
3. Stability AI
4. Replicate (SDXL)
5. Together AI
6. GetImg.ai
7. HuggingFace
8. Pollinations
9. DeepAI

## Future Enhancements
- [ ] Local Stable Diffusion support
- [ ] Image editing capabilities
- [ ] Style transfer
- [ ] Upscaling integration
- [ ] Prompt enhancement with LLMs
- [ ] Web UI interface
- [ ] Discord bot for Midjourney
- [ ] Batch processing GUI
- [ ] Image gallery manager