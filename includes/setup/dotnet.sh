# https://docs.microsoft.com/en-us/aspnet/core/publishing/linuxproduction
# https://www.codeproject.com/articles/1137493/deploy-asp-net-core-web-applications-on-ubuntu-lin
# https://www.junian.net/2017/01/running-your-first-aspnet-core-web-app-on-ubuntu-16-04.html
# https://aspnetmonsters.com/2016/07/2016-07-17-nginx/
# http://rehansaeed.com/nginx-asp-net-core-depth/
# http://dotnetthoughts.net/aspnet-core-with-nginx-as-reverse-proxy/
# https://medium.com/@BKSRacer930/asp-net-core-on-ubuntu-performance-c-mvc-nginx-and-fun-f84d8b9cbd02#.hf820nfa9
# http://coderscoffeehouse.com/tech/2016/08/19/real-world-aspnetcore-linux-example.html
# https://anthonysimmon.com/asp-net-5-nginx-reverse-proxy-linux/

sudo sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893
sudo apt-get update
sudo apt-get install dotnet-dev-1.0.0-preview2.1-003177

mkdir hwapp
cd hwapp
dotnet new
dotnet restore
dotnet run