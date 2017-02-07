cd $WEB_DIRECTORY

# Create sample app to validate dotnet core is installed
sudo dotnet new

# Create your dotnet core web app files

sudo rm project.json Program.cs

WriteLine "{" "$WEB_DIRECTORY/project.json"
WriteLine "    \"version\": \"1.0.0-*\"," "$WEB_DIRECTORY/project.json"
WriteLine "    \"buildOptions\": {" "$WEB_DIRECTORY/project.json"
WriteLine "        \"debugType\": \"portable\"," "$WEB_DIRECTORY/project.json"
WriteLine "        \"emitEntryPoint\": true" "$WEB_DIRECTORY/project.json"
WriteLine "      }," "$WEB_DIRECTORY/project.json"
WriteLine "    \"dependencies\": {" "$WEB_DIRECTORY/project.json"
WriteLine "        \"Microsoft.AspNetCore.Server.Kestrel\": \"1.1.0\"" "$WEB_DIRECTORY/project.json"
WriteLine "    }," "$WEB_DIRECTORY/project.json"
WriteLine "    \"frameworks\": {" "$WEB_DIRECTORY/project.json"
WriteLine "        \"netcoreapp1.1\": {" "$WEB_DIRECTORY/project.json"
WriteLine "            \"dependencies\": {" "$WEB_DIRECTORY/project.json"
WriteLine "                \"Microsoft.NETCore.App\": {" "$WEB_DIRECTORY/project.json"
WriteLine "                    \"type\": \"platform\"," "$WEB_DIRECTORY/project.json"
WriteLine "                    \"version\": \"1.1.0\"" "$WEB_DIRECTORY/project.json"
WriteLine "                }" "$WEB_DIRECTORY/project.json"
WriteLine "            }," "$WEB_DIRECTORY/project.json"
WriteLine "            \"imports\": \"dnxcore50\"" "$WEB_DIRECTORY/project.json"
WriteLine "        }" "$WEB_DIRECTORY/project.json"
WriteLine "    }" "$WEB_DIRECTORY/project.json"
WriteLine "}" "$WEB_DIRECTORY/project.json"

# -------------------------------------------------------------------------------

WriteLine "using System;" "$WEB_DIRECTORY/Program.cs"
WriteLine "using Microsoft.AspNetCore.Hosting;" "$WEB_DIRECTORY/Program.cs"

WriteLine " " "$WEB_DIRECTORY/Program.cs"

WriteLine "namespace $DOTNET_NAMESPACE" "$WEB_DIRECTORY/Program.cs"
WriteLine "{" "$WEB_DIRECTORY/Program.cs"
WriteLine "    public class Program" "$WEB_DIRECTORY/Program.cs"
WriteLine "    {" "$WEB_DIRECTORY/Program.cs"
WriteLine "        public static void Main(string[] args)" "$WEB_DIRECTORY/Program.cs"
WriteLine "        {" "$WEB_DIRECTORY/Program.cs"
WriteLine "            var host = new WebHostBuilder()" "$WEB_DIRECTORY/Program.cs"
WriteLine "                .UseUrls(\"http://*:5000\")" "$WEB_DIRECTORY/Program.cs"
WriteLine "                .UseKestrel()" "$WEB_DIRECTORY/Program.cs"
WriteLine "                .UseStartup<Startup>()" "$WEB_DIRECTORY/Program.cs"
WriteLine "                .Build();" "$WEB_DIRECTORY/Program.cs"

WriteLine " " "$WEB_DIRECTORY/Program.cs"

WriteLine "            host.Run();" "$WEB_DIRECTORY/Program.cs"
WriteLine "        }" "$WEB_DIRECTORY/Program.cs"
WriteLine "    }" "$WEB_DIRECTORY/Program.cs"
WriteLine "}" "$WEB_DIRECTORY/Program.cs"

# -------------------------------------------------------------------------------

WriteLine "using System;" "$WEB_DIRECTORY/Startup.cs"
WriteLine "using Microsoft.AspNetCore.Builder;" "$WEB_DIRECTORY/Startup.cs"
WriteLine "using Microsoft.AspNetCore.Hosting;" "$WEB_DIRECTORY/Startup.cs"
WriteLine "using Microsoft.AspNetCore.Http;" "$WEB_DIRECTORY/Startup.cs"
WriteLine "using Microsoft.Extensions.DependencyInjection;" "$WEB_DIRECTORY/Startup.cs"

WriteLine " " "$WEB_DIRECTORY/Startup.cs"

WriteLine "namespace $DOTNET_NAMESPACE" "$WEB_DIRECTORY/Startup.cs"
WriteLine "{" "$WEB_DIRECTORY/Startup.cs"
WriteLine "    public class Startup" "$WEB_DIRECTORY/Startup.cs"
WriteLine "    {" "$WEB_DIRECTORY/Startup.cs"
WriteLine "        // Use this method to add framework services (MVC, EF, Identity, Logging) " "$WEB_DIRECTORY/Startup.cs"
WriteLine "        // and application services " "$WEB_DIRECTORY/Startup.cs"
WriteLine "        public void ConfigureServices(IServiceCollection services)" "$WEB_DIRECTORY/Startup.cs"
WriteLine "        {" "$WEB_DIRECTORY/Startup.cs"
WriteLine "        }" "$WEB_DIRECTORY/Startup.cs"

WriteLine " " "$WEB_DIRECTORY/Startup.cs"

WriteLine "        // Use this method to configure the HTTP request pipeline." "$WEB_DIRECTORY/Startup.cs"
WriteLine "        public void Configure(IApplicationBuilder app)" "$WEB_DIRECTORY/Startup.cs"
WriteLine "        {" "$WEB_DIRECTORY/Startup.cs"
WriteLine "            app.Run(context =>" "$WEB_DIRECTORY/Startup.cs"
WriteLine "            {" "$WEB_DIRECTORY/Startup.cs"
WriteLine "                return context.Response.WriteAsync(\"Hello from ASP.NET Core!\");" "$WEB_DIRECTORY/Startup.cs"
WriteLine "            });" "$WEB_DIRECTORY/Startup.cs"
WriteLine "        }" "$WEB_DIRECTORY/Startup.cs"
WriteLine "    }" "$WEB_DIRECTORY/Startup.cs"
WriteLine "}" "$WEB_DIRECTORY/Startup.cs"

if [ "$NGINX_ENABLED" = "true" ]; then
    sudo service nginx restart
fi



# Restore packages
sudo dotnet restore

# Run the .netcore app
sudo dotnet run

sudo dotnet publish

