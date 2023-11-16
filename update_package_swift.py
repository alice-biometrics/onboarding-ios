import re
import hashlib
import sys
from pathlib import Path

# Function to update Package.swift file
def update_package_swift(version, checksum):
    package_swift_path = Path("Package.swift")

    # Read the content of Package.swift
    with package_swift_path.open() as file:
        content = file.read()

    # Update the version and checksum using regular expressions
    content = re.sub(r'let version = ".+"', f'let version = "{version}"', content)
    content = re.sub(r'let checksum = ".+"', f'let checksum = "{checksum}"', content)

    # Write the updated content back to Package.swift
    with package_swift_path.open("w") as file:
        file.write(content)

# Check if version and checksum are provided as command-line arguments
if len(sys.argv) != 3:
    print("Usage: python update_package_swift.py <version> <checksum>")
    sys.exit(1)

# Extract version and checksum from command-line arguments
version = sys.argv[1]
checksum = sys.argv[2]

# Update Package.swift with the provided version and checksum
update_package_swift(version, checksum)

print(f"Package.swift updated with version {version} and checksum {checksum}")
