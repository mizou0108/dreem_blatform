<?php
$signatures = json_decode(file_get_contents('signatures.json'), true);
echo "<!DOCTYPE html><html><head><meta charset='UTF-8'>
<title>Dreem Fortress™ - سجل التواقيع</title>
<style>
body{font-family:Arial;background:#f2f2f2;padding:20px}
h1{text-align:center}table{width:100%;border-collapse:collapse;margin-top:20px}
th,td{border:1px solid #ccc;padding:8px;text-align:left}
th{background:#333;color:white}tr:nth-child(even){background:#f9f9f9}
</style></head><body>";
echo "<h1>Dreem Fortress™ - سجل التواقيع</h1><table><tr>
<th>#</th><th>الملف</th><th>البصمة</th><th>الزمن</th></tr>";
foreach ($signatures as $i => $e) {
echo "<tr><td>".($i+1)."</td><td>".htmlspecialchars($e['file'])."</td>
<td><code>".htmlspecialchars($e['signature'])."</code></td>
<td>".htmlspecialchars($e['timestamp'])."</td></tr>";}
echo "</table></body></html>";
?>
