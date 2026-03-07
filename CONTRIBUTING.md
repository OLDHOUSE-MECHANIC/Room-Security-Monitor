# Contributing to Room Security Monitor

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## How to Contribute

### Reporting Bugs

If you find a bug, please open an issue with:
- A clear, descriptive title
- Steps to reproduce the bug
- Expected behavior vs actual behavior
- Your system information:
  - OS and version
  - Python version
  - OpenCV version
  - Camera model (if relevant)
- Error messages or logs
- Screenshots (if applicable)

### Suggesting Features

Feature suggestions are welcome! Please open an issue with:
- Clear description of the feature
- Why it would be useful
- How it might work
- Any implementation ideas you have

### Pull Requests

1. **Fork the repository**
   ```bash
   git clone https://github.com/yourusername/room-security-monitor.git
   cd room-security-monitor
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Write clean, readable code
   - Follow existing code style
   - Add comments where necessary
   - Test your changes thoroughly

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add feature: brief description"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Open a Pull Request**
   - Describe what your PR does
   - Reference any related issues
   - Include testing information

## Code Style Guidelines

### Python Code
- Follow PEP 8 style guide
- Use meaningful variable names
- Add docstrings to functions and classes
- Keep functions focused and small
- Use type hints where appropriate

Example:
```python
def detect_motion(frame: np.ndarray, threshold: int = 25) -> bool:
    """
    Detect motion in a video frame.
    
    Args:
        frame: Input video frame
        threshold: Motion sensitivity threshold
        
    Returns:
        True if motion detected, False otherwise
    """
    # Implementation here
    pass
```

### Bash Scripts
- Use meaningful variable names in UPPER_CASE
- Add comments for complex operations
- Include error checking
- Make scripts portable

### Documentation
- Keep README.md up to date
- Update CHANGELOG.md for significant changes
- Add inline comments for complex logic
- Update INSTALL.md if installation changes

## Testing

Before submitting a PR:

1. **Test on your system**
   ```bash
   ./monitor
   # Test motion detection
   # Check recordings are saved
   # Verify file naming
   ```

2. **Test edge cases**
   - Camera not found
   - Low disk space
   - Invalid settings
   - Keyboard interrupts

3. **Check for errors**
   ```bash
   # Run with different settings
   # Test with show_feed=True and False
   # Verify cleanup on exit
   ```

## Priority Areas for Contribution

### High Priority
- Cross-platform testing (other Linux distros, macOS, Windows)
- Performance optimizations
- Better error handling
- Unit tests

### Medium Priority
- AI-powered human detection
- Configuration file support
- Web interface
- Email notifications

### Low Priority (but welcome!)
- Additional codecs
- UI improvements
- Documentation improvements
- Example use cases

## Development Setup

```bash
# Clone your fork
git clone https://github.com/yourusername/room-security-monitor.git
cd room-security-monitor

# Create development venv
python3 -m venv dev_env
source dev_env/bin/activate

# Install dependencies
pip install opencv-python numpy

# Install development tools
pip install pytest black flake8

# Run tests (when available)
pytest

# Check code style
black security_monitor.py
flake8 security_monitor.py
```

## Code Review Process

1. Maintainer reviews PR
2. Feedback provided if needed
3. Changes requested or approved
4. Merged into main branch
5. Added to next release

## Communication

- **Issues**: For bugs and feature requests
- **Pull Requests**: For code contributions
- **Discussions**: For general questions and ideas

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Accept constructive criticism gracefully
- Focus on what's best for the community
- Show empathy towards others

### Unacceptable Behavior

- Harassment or discriminatory language
- Trolling or insulting comments
- Publishing private information
- Other unprofessional conduct

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Questions?

Open an issue with the "question" label or start a discussion!

## Thank You!

Every contribution helps make this project better. We appreciate your time and effort! 🙏
