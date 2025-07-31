import SwiftUI

struct HomeView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?

    var tip: String {
    if temp > 35 { return "Stay hydrated 💧" }
    else if condition == "Rain" { return "Carry an umbrella ☔" }
    else { return "Have a great day 🌤" }
    
    }

    
    var body: some View {
        VStack{
            if let location = locationManager.location{
                if let weather = weather{
                    WeatherView(weather: weather)
                } else{
                    LoadingView()
                        .task {
                            do{
                                weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                                
                            }catch{
                                print("error getting weather: \(error)")
                            }
                        }
                    
                }
            }
            else{
                if locationManager.isLoading{
                    LoadingView()
                }else{
                    WelcomeView()
                        .environmentObject(locationManager)
                    }
                }
            }
        .background(LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom))
        .font(.custom("Avenir", size: 20))

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
