# GlobalSecurity PDF Downloader

        (\(o_o)/)   
         (  |  )  💾  // PDF Download Mode Activated!
         _/   \_  

          (\o/)  
          -(_)-  🤓📚 // Time to collect some knowledge!
          /   \  

        NAFO Radio - Knowledge Acquisition Division
        ----------------------------------------

## Description

This PowerShell script automates the downloading of military field manuals (FM) from GlobalSecurity.org. It uses Python under the hood to efficiently download PDF documents with progress tracking and concurrent downloads.

## Prerequisites

- Windows PowerShell
- Python 3.x
- Internet connection

## Required Python Packages

The script will automatically install these packages if they're missing:
- requests
- beautifulsoup4
- tqdm

## Installation

1. Download the `Download-GlobalSecurityPDFs.ps1` script
2. Ensure Python 3.x is installed and available in your system PATH
3. Run the script from PowerShell


The script will:
1. ---- 
2. Check for Python installation
3. Install required Python packages
4. Create a directory named `FM_manuals` in the current location
5. Download all available PDF files from globalsecurity.org/military/library/policy/army/fm/

## Features

- Concurrent downloads (up to 5 simultaneous downloads)
- Progress bars for each download
- Skips existing files to avoid re-downloading
- Error handling and reporting
- Clean temporary file management
- User-friendly progress display

## Output

Downloaded files will be saved to the `FM_manuals` directory in your current working directory.
1/31/25 - Added https://www.cia.gov/static/5c875f3ec660e092cf893f60b4a288df/SimpleSabotage.pdf to the downloads. 

## Error Handling

The script includes error handling for:
- Missing Python installation
- Network connectivity issues
- Failed downloads
- Package installation problems

## Notes

- The script uses a respectful User-Agent string
- Downloads are performed with proper error handling and progress tracking
- Temporary files are automatically cleaned up after execution

## Disclaimer

This tool is provided by NAFO Radio - Knowledge Acquisition Division for educational purposes. Please ensure you have the right to download any materials before using this script.

## License

Free to use and modify. Please credit NAFO Radio if you redistribute.

## Support

For issues or questions, please open an issue in the repository.

---
Created by NAFO Radio - Knowledge Acquisition Division 🐕
