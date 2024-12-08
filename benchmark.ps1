# PowerShell Script to Compile and Run Java Programs Multiple Times

# Prompt user for the number of iterations
$numIterations = Read-Host -Prompt "Enter the number of iterations"

# Measure the start time for total process
$totalStartTime = Get-Date

Write-Output "Compiling Java programs..."
$compileStartTime = Get-Date

# Compile the Java programs
javac Benchmark.java
javac FileGenerator.java

$compileEndTime = Get-Date
$compileTime = (New-TimeSpan -Start $compileStartTime -End $compileEndTime).TotalMilliseconds

Write-Output "Compilation completed in $compileTime milliseconds"

# Run the FileGenerator to create the text file
Write-Output "Running FileGenerator to create largefile.txt..."
java FileGenerator

# Variables to store the sum of benchmark execution times
$totalSingleCoreTime = 0
$totalMultiCoreTime = 0

for ($i = 1; $i -le $numIterations; $i++) {
    Write-Output "Running iteration $i for single-core benchmark..."

    # Run the Benchmark program in single-core mode and measure its runtime
    $singleCoreStartTime = Get-Date
    java Benchmark single
    $singleCoreEndTime = Get-Date

    # Calculate the single-core benchmark execution time for this iteration
    $singleCoreTime = (New-TimeSpan -Start $singleCoreStartTime -End $singleCoreEndTime).TotalMilliseconds
    $totalSingleCoreTime += $singleCoreTime

    Write-Output "Single-core benchmark iteration $i completed in $singleCoreTime milliseconds"

    Write-Output "Running iteration $i for multi-core benchmark..."

    # Run the Benchmark program in multi-core mode and measure its runtime
    $multiCoreStartTime = Get-Date
    java Benchmark multi
    $multiCoreEndTime = Get-Date

    # Calculate the multi-core benchmark execution time for this iteration
    $multiCoreTime = (New-TimeSpan -Start $multiCoreStartTime -End $multiCoreEndTime).TotalMilliseconds
    $totalMultiCoreTime += $multiCoreTime

    Write-Output "Multi-core benchmark iteration $i completed in $multiCoreTime milliseconds"
}

# Measure the end time for total process
$totalEndTime = Get-Date

# Calculate average benchmark execution time
$averageSingleCoreTime = $totalSingleCoreTime / $numIterations
$averageMultiCoreTime = $totalMultiCoreTime / $numIterations

# Standardizing scores on a scale of 0 to 100
$referenceSingleCoreTime = 1000 # Adjust based on a reference system
$referenceMultiCoreTime = 2000  # Adjust based on a reference system

$singleCoreScore = [math]::Min(100, [math]::Round(($referenceSingleCoreTime / $averageSingleCoreTime) * 100))
$multiCoreScore = [math]::Min(100, [math]::Round(($referenceMultiCoreTime / $averageMultiCoreTime) * 100))

# Output the timing results in a nicely formatted way
Write-Output "----------------------------"
Write-Output "Benchmark Summary"
Write-Output "----------------------------"
Write-Output "Compilation time: $compileTime milliseconds"
Write-Output "Total time taken (compilation + execution): $((New-TimeSpan -Start $totalStartTime -End $totalEndTime).TotalSeconds) seconds"
Write-Output "Average single-core benchmark execution time over $numIterations iterations: $averageSingleCoreTime milliseconds"
Write-Output "Average multi-core benchmark execution time over $numIterations iterations: $averageMultiCoreTime milliseconds"
Write-Output "Single-core performance score: $singleCoreScore"
Write-Output "Multi-core performance score: $multiCoreScore"
Write-Output "----------------------------"
