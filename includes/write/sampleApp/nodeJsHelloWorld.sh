# Create your nodejs entry file.
WriteLine "#!/usr/bin/env nodejs" "$WEB_DIRECTORY/$SITE_INIT_FILE_NAME"
WriteLine "var http = require('http');" "$WEB_DIRECTORY/$SITE_INIT_FILE_NAME"
WriteLine "http.createServer(function (req, res) {" "$WEB_DIRECTORY/$SITE_INIT_FILE_NAME"
WriteLine "  res.writeHead(200, {'Content-Type': 'text/plain'});" "$WEB_DIRECTORY/$SITE_INIT_FILE_NAME"
WriteLine "  res.end('Hello World\n');" "$WEB_DIRECTORY/$SITE_INIT_FILE_NAME"
WriteLine "}).listen(8080, 'localhost');" "$WEB_DIRECTORY/$SITE_INIT_FILE_NAME"
WriteLine "console.log('Server running at http://localhost:8080/');" "$WEB_DIRECTORY/$SITE_INIT_FILE_NAME"

# Start the nodejs application with PM2. The application will auto-restart from this point.
sudo pm2 start $WEB_DIRECTORY/$SITE_INIT_FILE_NAME > /dev/null
sudo pm2 save
sudo pm2 dump