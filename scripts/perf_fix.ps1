$ErrorActionPreference = 'Stop'
$p = 'index.html'
$c = Get-Content -Raw -Encoding UTF8 -Path $p

# Add width/height to hero kv image
$c = [Regex]::Replace($c, '(<img[^>]*class="kv"[^>]*decoding="async")(\s*/?>)', '$1 width="1600" height="900"$2', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

# Add lazy/async and width/height to compare photos specifically by src
$c = [Regex]::Replace($c, '(<img[^>]*class="compare-photo"[^>]*src="img/aka.jpg"[^>]*)(>)', '$1 loading="lazy" decoding="async" width="800" height="600"$2', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
$c = [Regex]::Replace($c, '(<img[^>]*class="compare-photo"[^>]*src="img/kuro.jpg"[^>]*)(>)', '$1 loading="lazy" decoding="async" width="800" height="600"$2', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
$c = [Regex]::Replace($c, '(<img[^>]*class="compare-photo"[^>]*src="img/nanohana.jpg"[^>]*)(>)', '$1 loading="lazy" decoding="async" width="800" height="600"$2', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

Set-Content -Path $p -Encoding UTF8 -Value $c
Write-Output 'perf_fix applied'

