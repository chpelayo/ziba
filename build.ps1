
# Define target platforms and architectures
$targets = @(
    "android/arm64",
    "darwin/amd64",
    "darwin/arm64",
    "linux/amd64",
    "linux/arm64",
    "windows/amd64",
    "windows/arm64"
)

# Output directory for binaries
$outputDir = "build"

# Ensure the output directory exists
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# Build for each target
foreach ($target in $targets) {
    $os, $arch = $target -split "/"
    $outputName = "$outputDir/ziba-$os-$arch"

    # Append .exe for Windows binaries
    if ($os -eq "windows") {
        $outputName += ".exe"
    }

    Write-Host "Building for $os/$arch..."
    $env:GOOS = $os
    $env:GOARCH = $arch
    & go build -o $outputName

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to build for $os/$arch"
        exit 1
    }
}

Write-Host "Build completed. Binaries are in the '$outputDir' directory."
