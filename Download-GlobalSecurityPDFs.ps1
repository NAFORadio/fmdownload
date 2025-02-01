# Requires Python 3.x and pip
# First-time setup: Install required Python packages
function Install-RequiredPackages {
    Write-Output "Checking and installing required Python packages..."
    python -m pip install requests beautifulsoup4 tqdm
}

# Add the ASCII art function
function Show-NerdArt {
    Write-Output @"

        (\(o_o)/)   
         (  |  )  💾  // PDF Download Mode Activated!
         _/   \_  

          (\o/)  
          -(_)-  🤓📚 // Time to collect some knowledge!
          /   \  

        NAFO Radio - Knowledge Acquisition Division
        ----------------------------------------
"@
}

# Create Python script content
$pythonScript = @'
import os
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin
import time
from tqdm import tqdm
import concurrent.futures

class PDFDownloader:
    def __init__(self, base_url, save_dir):
        self.base_url = base_url
        self.save_dir = save_dir
        self.session = requests.Session()
        self.headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }
        
    def setup_directory(self):
        os.makedirs(self.save_dir, exist_ok=True)
        print(f"Saving files to: {os.path.abspath(self.save_dir)}")

    def get_pdf_links(self):
        try:
            print("Fetching PDF links...")
            # First get PDFs from the base URL
            response = self.session.get(self.base_url, headers=self.headers)
            response.raise_for_status()
            
            soup = BeautifulSoup(response.text, "html.parser")
            pdf_links = []
            
            for a in soup.find_all("a", href=True):
                href = a["href"]
                if href.lower().endswith('.pdf'):
                    full_url = urljoin(self.base_url, href)
                    pdf_links.append({
                        'url': full_url,
                        'name': os.path.basename(href)
                    })
            
            # Add the Simple Sabotage manual
            pdf_links.append({
                'url': 'https://www.cia.gov/static/5c875f3ec660e092cf893f60b4a288df/SimpleSabotage.pdf',
                'name': 'SimpleSabotage.pdf'
            })
            
            print(f"Found {len(pdf_links)} PDF files")
            return pdf_links
        
        except requests.RequestException as e:
            print(f"Error fetching PDF links: {e}")
            return []

    def download_pdf(self, pdf_info):
        url = pdf_info['url']
        filename = pdf_info['name']
        filepath = os.path.join(self.save_dir, filename)
        
        if os.path.exists(filepath):
            print(f"Skipping existing file: {filename}")
            return False
        
        try:
            response = self.session.get(url, headers=self.headers, stream=True)
            response.raise_for_status()
            
            total_size = int(response.headers.get('content-length', 0))
            
            with open(filepath, 'wb') as f, tqdm(
                desc=filename,
                total=total_size,
                unit='iB',
                unit_scale=True,
                unit_divisor=1024,
            ) as pbar:
                for data in response.iter_content(chunk_size=1024):
                    size = f.write(data)
                    pbar.update(size)
            
            return True
            
        except requests.RequestException as e:
            print(f"Error downloading {filename}: {e}")
            if os.path.exists(filepath):
                os.remove(filepath)
            return False

    def download_all(self, max_workers=5):
        self.setup_directory()
        pdf_links = self.get_pdf_links()
        
        if not pdf_links:
            print("No PDFs found to download")
            return
        
        print(f"\nStarting download of {len(pdf_links)} files...")
        successful = 0
        failed = 0
        
        with concurrent.futures.ThreadPoolExecutor(max_workers=max_workers) as executor:
            future_to_pdf = {executor.submit(self.download_pdf, pdf): pdf for pdf in pdf_links}
            
            for future in concurrent.futures.as_completed(future_to_pdf):
                pdf = future_to_pdf[future]
                try:
                    if future.result():
                        successful += 1
                    else:
                        failed += 1
                except Exception as e:
                    print(f"Error downloading {pdf['name']}: {e}")
                    failed += 1
        
        print(f"\nDownload complete!")
        print(f"Successfully downloaded: {successful}")
        print(f"Failed downloads: {failed}")

def main():
    base_url = "https://www.globalsecurity.org/military/library/policy/army/fm/"
    save_dir = "FM_manuals"
    
    downloader = PDFDownloader(base_url, save_dir)
    downloader.download_all()

if __name__ == "__main__":
    main()
'@

# Function to check Python installation
function Test-PythonInstallation {
    try {
        $pythonVersion = python --version
        Write-Output "Found Python: $pythonVersion"
        return $true
    }
    catch {
        Write-Error "Python is not installed or not in PATH"
        return $false
    }
}

# Main execution
function Start-PDFDownload {
    Show-NerdArt  # Reusing your existing ASCII art function
    
    Write-Output "Starting GlobalSecurity PDF Downloader"
    Write-Output "------------------------------------"
    
    # Check Python installation
    if (-not (Test-PythonInstallation)) {
        Write-Error "Please install Python 3.x before running this script"
        return
    }
    
    # Create temporary Python script
    $tempScript = Join-Path $env:TEMP "download_pdfs.py"
    $pythonScript | Out-File -FilePath $tempScript -Encoding UTF8
    
    try {
        # Install required packages
        Install-RequiredPackages
        
        # Run the Python script
        Write-Output "`nStarting PDF download..."
        python $tempScript
    }
    catch {
        Write-Error "An error occurred: $_"
    }
    finally {
        # Cleanup
        if (Test-Path $tempScript) {
            Remove-Item $tempScript -Force
        }
    }
}

# Run the downloader
Start-PDFDownload 