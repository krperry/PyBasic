"""
Host platform detection module for PyBasic.

This module provides a Host class that detects the current platform,
with special support for BTSpeak devices.
"""

PLATFORM_NAME= 'unknown'
# Try to detect BTSpeak first
try:
    from BTSpeak import product
    from BTSpeak import host as bt_host
    PLATFORM_NAME = product.brandName
    if PLATFORM_NAME.startswith("BT Braille"):
        PLATFORM_NAME= "BT Braille"
except ImportError:
    # BTSpeak not available, fall back to standard detection
    import platform
    
    system = platform.system().lower()
    
    if system == 'linux':
        PLATFORM_NAME= 'linux'
    elif system == 'darwin':
        PLATFORM_NAME= 'mac'
    elif system == 'windows':
        PLATFORM_NAME= 'windows'
    else:
        PLATFORM_NAME._platform = system  # Return whatever platform.system() gives us





class BasicHost:
    """
    A class to detect the current host platform.
    
    Attempts to detect BTSpeak first via the BTSpeak.product module,
    then falls back to standard platform detection for Linux, Mac, and Windows.
    """
    
    def __init__(self):
        """Initialize the Host detector."""
        self._platform = PLATFORM_NAME
    
    
    @property
    def platform_name(self):
        """
        Get the detected platform name.
        
        Returns:
            str: The platform name ('linux', 'mac', 'windows', or BTSpeak brand name)
        """
        return self._platform
    
    @property
    def is_btspeak(self):
        """
        Check if running on BTSpeak.
        
        Returns:
            bool: True if BTSpeak is detected, False otherwise
        """
        return self._platform=="BT Speak"
    
    
    @property
    def is_btbraille(self):
        """
        Check if running on BTBraille
        
        Returns:
            bool: True if BTBraille is detected, False otherwise
        """
        if self._platform=="BT Braille":
            return True
        return False
    
    @property
    def is_btdevice(self):
        """
        Check if running on BTSpeak or BTBraille
        
        Returns:
            bool: True if BTSpeak or BTBraille is detected, False otherwise
        """
        return self._platform=="BT Speak" or self._platform=="BT Braille"
    
    @property
    def is_linux(self):
        """Check if running on Linux."""
        return self._platform == 'linux'
    
    @property
    def is_mac(self):
        """Check if running on Mac."""
        return self._platform == 'mac'
    
    @property
    def is_windows(self):
        """Check if running on Windows."""
        return self._platform == 'windows'
    
    def __str__(self):
        """String representation of the host."""
        return self._platform
    
    def __repr__(self):
        """Developer representation of the host."""
        return f"Host(platform='{self._platform}')"
    
    def say(self, *args, **kwargs):
        """
        Output text as speech.
        
        On BTSpeak devices, uses host.say() for text-to-speech.
        On other platforms, falls back to print().
        
        Args:
            *args: Variable arguments, same as print()
            **kwargs: Keyword arguments, same as print()
        """
        # Convert args to a single string like print() does
        text = ' '.join(str(arg) for arg in args)
        
        print(*args, **kwargs)
        if self.is_btdevice:
                bt_host.say(text)

                
    def braille(self, *args, **kwargs):
        """
        Output text to braille display.
        
        On BTBraille , uses host.braille() for braille output.
        On BTspeak uses say
        On other platforms, falls back to print().
        
        Args:
            *args: Variable arguments, same as print()
            **kwargs: Keyword arguments, same as print()
        """
        # Convert args to a single string like print() does
        text = ' '.join(str(arg) for arg in args)
        
        if self.is_btbraille:
            bt_host.braille(text)
        elif self._platform=="BT Speak":
            bt_host.say(text)
        else:
            print(*args, **kwargs)

    def print(self, *args, **kwargs):
        """
        Output text to display.
        
    On BTSpeak devices, uses     both speech and standard print.
On other platforms, falls back to print().
        
        Args:
            *args: Variable arguments, same as print()
            **kwargs: Keyword arguments, same as print()
        """

        # Convert args to a single string like print() does
        text = ' '.join(str(arg) for arg in args)

        if self.is_btdevice:
            print(*args, **kwargs)
            bt_host.say("say: "+text)
        else:
            print(*args, **kwargs       )

# Create a singleton instance for easy access
host = BasicHost()
