$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
function Resize-Image($inPath, $outPath, $maxWidth){
  if(!(Test-Path $inPath)){ throw "missing: $inPath" }
  [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($outPath)) | Out-Null
  $bmp = New-Object System.Drawing.Bitmap $inPath
  try {
    $w = [int]$bmp.Width; $h = [int]$bmp.Height
    if($w -le $maxWidth){ Copy-Item -Force $inPath $outPath; return }
    $ratio = $maxWidth / $w
    $newW = [int]$maxWidth
    $newH = [int][Math]::Round($h * $ratio)
    $dest = New-Object System.Drawing.Bitmap $newW, $newH
    try {
      $g = [System.Drawing.Graphics]::FromImage($dest)
      try {
        $g.CompositingQuality = 'HighQuality'
        $g.InterpolationMode = 'HighQualityBicubic'
        $g.SmoothingMode = 'HighQuality'
        $g.DrawImage($bmp, 0,0, $newW, $newH)
      } finally { $g.Dispose() }
      $codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
      $params = New-Object System.Drawing.Imaging.EncoderParameters 1
      $quality = [System.Drawing.Imaging.Encoder]::Quality
      $ep = New-Object System.Drawing.Imaging.EncoderParameter $quality, 90
      $params.Param[0] = $ep
      $dest.Save($outPath, $codec, $params)
    } finally { $dest.Dispose() }
  } finally { $bmp.Dispose() }
}

$targets = @(
  @{ name='tantanmen'; widths=@(400,800,1200,1600) },
  @{ name='aka'; widths=@(400,800) },
  @{ name='kuro'; widths=@(400,800) },
  @{ name='nanohana'; widths=@(400,800,1200) },
  @{ name='gaikan'; widths=@(400,800,1200) },
  @{ name='naisou'; widths=@(400,800,1200) }
)

foreach($t in $targets){
  $base = Join-Path 'img' ("{0}.jpg" -f $t.name)
  foreach($w in $t.widths){
    $out = Join-Path 'img' ("{0}-w{1}.jpg" -f $t.name, $w)
    Resize-Image -inPath $base -outPath $out -maxWidth $w
    Write-Host ("w{0} -> {1}" -f $w, $out)
  }
}
