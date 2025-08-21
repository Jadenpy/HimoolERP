# 项目根目录
$root = "C:\Users\A\Documents\MyCodes\HimoolERP"

# 最大显示深度
$maxDepth = 3

# 输出文件
$outputFile = "$root\tree.txt"

# 根目录深度
$rootDepth = $root.Split('\').Count

# 清空输出文件
"" | Out-File -FilePath $outputFile -Encoding utf8

function Print-Tree($path, $prefix = "") {
    $items = Get-ChildItem -Path $path | Where-Object { $_.Name -ne ".venv" } | Sort-Object PSIsContainer -Descending
    $count = $items.Count
    for ($i = 0; $i -lt $count; $i++) {
        $item = $items[$i]
        $isLast = $i -eq ($count - 1)

        if ($isLast) {
            $connector = "\--"
        } else {
            $connector = "|--"
        }

        "$prefix$connector$item" | Out-File -FilePath $outputFile -Encoding utf8 -Append

        if ($item.PSIsContainer) {
            $newDepth = $item.FullName.Split('\').Count - $rootDepth + 1
            if ($newDepth -lt $maxDepth) {
                if ($isLast) {
                    $newPrefix = $prefix + "   "
                } else {
                    $newPrefix = $prefix + "|  "
                }
                Print-Tree $item.FullName $newPrefix
            }
        }
    }
}

# 写入根目录
$root | Out-File -FilePath $outputFile -Encoding utf8
# 打印目录树
Print-Tree $root

Write-Output "Directory tree has been saved to $outputFile"
