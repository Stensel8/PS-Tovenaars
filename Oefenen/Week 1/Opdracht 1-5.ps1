$browser = Read-Host "Enter your browser of choice (e.g., Chrome, MSEdge, Firefox, Brave)"

Start-Process $browser -ArgumentList "https://youtu.be/xvFZjo5PgG0?si=K0bl21ezUVUk8MMw" -WindowStyle Maximized