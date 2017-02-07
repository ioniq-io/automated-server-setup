cd $WEB_DIRECTORY

# Comment on console sample app, web app will be created instead.
# sudo dotnet new

# Create your dotnet core web app files
.
WriteLine "using System.IO;" "$WEB_DIRECTORY/Program.cs"
WriteLine "using Microsoft.AspNetCore.Hosting;" "$WEB_DIRECTORY/Program.cs"
WriteLine "using Microsoft.Extensions.Configuration;" "$WEB_DIRECTORY/Program.cs"

WriteLine "" "$WEB_DIRECTORY/Program.cs"

WriteLine "public class Program" "$WEB_DIRECTORY/Program.cs"
WriteLine "{" "$WEB_DIRECTORY/Program.cs"

WriteLine "    public static void Main(string[] args)" "$WEB_DIRECTORY/Program.cs"
WriteLine "    {" "$WEB_DIRECTORY/Program.cs"

WriteLine "        var builder = new ConfigurationBuilder()" "$WEB_DIRECTORY/Program.cs"
WriteLine "            .SetBasePath(Directory.GetCurrentDirectory())" "$WEB_DIRECTORY/Program.cs"
WriteLine "            .AddJsonFile(\"appsettings.json\", optional: true)" "$WEB_DIRECTORY/Program.cs"
WriteLine "            .Build();" "$WEB_DIRECTORY/Program.cs"

WriteLine "" "$WEB_DIRECTORY/Program.cs"

WriteLine "        var host = new WebHostBuilder()" "$WEB_DIRECTORY/Program.cs"
WriteLine "            .UseKestrel()" "$WEB_DIRECTORY/Program.cs"
WriteLine "            .UseConfiguration(builder)" "$WEB_DIRECTORY/Program.cs"
WriteLine "            .UseContentRoot(Directory.GetCurrentDirectory())" "$WEB_DIRECTORY/Program.cs"
WriteLine "            .UseStartup<Startup>()" "$WEB_DIRECTORY/Program.cs"
WriteLine "            .Build();" "$WEB_DIRECTORY/Program.cs"

WriteLine "        host.Run();" "$WEB_DIRECTORY/Program.cs"

WriteLine "    }" "$WEB_DIRECTORY/Program.cs"

WriteLine "}" "$WEB_DIRECTORY/Program.cs"

# ----------------------------------------------------------------------------------

WriteLine "using Microsoft.AspNetCore.Builder;" "$WEB_DIRECTORY/Startup.cs"
WriteLine "using Microsoft.AspNetCore.Hosting;" "$WEB_DIRECTORY/Startup.cs"
WriteLine "using Microsoft.AspNetCore.Http;" "$WEB_DIRECTORY/Startup.cs"

WriteLine "" "$WEB_DIRECTORY/Startup.cs"

WriteLine "public class Startup" "$WEB_DIRECTORY/Startup.cs"
WriteLine "{" "$WEB_DIRECTORY/Startup.cs"
WriteLine "    public void Configure(IApplicationBuilder app)" "$WEB_DIRECTORY/Startup.cs"
WriteLine "    {" "$WEB_DIRECTORY/Startup.cs"
WriteLine "        app.Run(context =>" "$WEB_DIRECTORY/Startup.cs"
WriteLine "        {" "$WEB_DIRECTORY/Startup.cs"
WriteLine "            return context.Response.WriteAsync("Hello World!");" "$WEB_DIRECTORY/Startup.cs"
WriteLine "        });" "$WEB_DIRECTORY/Startup.cs"
WriteLine "    }" "$WEB_DIRECTORY/Startup.cs"
WriteLine "}" "$WEB_DIRECTORY/Startup.cs"

# ----------------------------------------------------------------------------------

WriteLine "{" "$WEB_DIRECTORY/project.json"
WriteLine "  \"version\": \"1.0.0-*\"," "$WEB_DIRECTORY/project.json"
WriteLine "  \"buildOptions\": {" "$WEB_DIRECTORY/project.json"
WriteLine "    \"debugType\": \"portable\"," "$WEB_DIRECTORY/project.json"
WriteLine "    \"emitEntryPoint\": true" "$WEB_DIRECTORY/project.json"
WriteLine "  }," "$WEB_DIRECTORY/project.json"
WriteLine "  \"dependencies\": {" "$WEB_DIRECTORY/project.json"
WriteLine "    \"Microsoft.AspNetCore.Mvc\": \"1.0.0\"," "$WEB_DIRECTORY/project.json"
WriteLine "    \"Microsoft.AspNetCore.Server.Kestrel\": \"1.0.0\"," "$WEB_DIRECTORY/project.json"
WriteLine "    \"Microsoft.Extensions.Configuration.Json\": \"1.0.0\"," "$WEB_DIRECTORY/project.json"
WriteLine "    \"Microsoft.Extensions.Options.ConfigurationExtensions\": \"1.0.0\"" "$WEB_DIRECTORY/project.json"
WriteLine "  }," "$WEB_DIRECTORY/project.json"
WriteLine "  \"frameworks\": {" "$WEB_DIRECTORY/project.json"
WriteLine "    \"netcoreapp1.0\": {" "$WEB_DIRECTORY/project.json"
WriteLine "      \"dependencies\": {" "$WEB_DIRECTORY/project.json"
WriteLine "        \"Microsoft.NETCore.App\": {" "$WEB_DIRECTORY/project.json"
WriteLine "          \"type\": \"platform\"," "$WEB_DIRECTORY/project.json"
WriteLine "          \"version\": \"1.0.0\"" "$WEB_DIRECTORY/project.json"
WriteLine "        }," "$WEB_DIRECTORY/project.json"
WriteLine "        \"Microsoft.AspNetCore.Server.Kestrel\": \"1.0.0\"" "$WEB_DIRECTORY/project.json"
WriteLine "      }," "$WEB_DIRECTORY/project.json"
WriteLine "      \"imports\": \"dnxcore50\"" "$WEB_DIRECTORY/project.json"
WriteLine "    }" "$WEB_DIRECTORY/project.json"
WriteLine "  }," "$WEB_DIRECTORY/project.json"
WriteLine "  \"publishOptions\": {" "$WEB_DIRECTORY/project.json"
WriteLine "    \"include\": [" "$WEB_DIRECTORY/project.json"
WriteLine "      \"wwwroot\"," "$WEB_DIRECTORY/project.json"
WriteLine "      \"Views\"," "$WEB_DIRECTORY/project.json"
WriteLine "      \"appsettings.json\"" "$WEB_DIRECTORY/project.json"
WriteLine "    ]" "$WEB_DIRECTORY/project.json"
WriteLine "  }" "$WEB_DIRECTORY/project.json"
WriteLine "}" "$WEB_DIRECTORY/project.json"

# ----------------------------------------------------------------------------------

WriteLine "{" "$WEB_DIRECTORY/appsettings.json"
WriteLine "    \"server.urls\": \"http://localhost:5001\"" "$WEB_DIRECTORY/appsettings.json"
WriteLine "}" "$WEB_DIRECTORY/appsettings.json"

# Restore packages
sudo dotnet restore

# Run the .netcore app
sudo dotnet run

sudo dotnet publish