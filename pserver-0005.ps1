$a = (Get-ChildItem C:\temp\Svr*).Count;
if ($a -lt 1000) { 
    echo "OK: $a"
    exit 0
} else { 
    echo "KO: $a"
    exit 2
}