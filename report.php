<?php
$today = date("Y-m-d");
$log_file = "logs/logins_$today.txt";

echo "<!DOCTYPE html><html><head><meta charset='UTF-8'><title>تقرير تسجيلات $today</title></head><body>";
echo "<h2>سجل تسجيل الدخول لليوم: $today</h2>";

if (file_exists($log_file)) {
  echo "<ul>";
  $lines = file($log_file);
  foreach ($lines as $line) {
    echo "<li>" . htmlspecialchars($line) . "</li>";
  }
  echo "</ul>";
} else {
  echo "<p>لا يوجد أي تسجيلات لهذا اليوم.</p>";
}

echo "</body></html>";
?>
