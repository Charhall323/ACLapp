//
//  FAQviewcontroller.swift
//  ACLApp
//
//  Created by  Charlotte Hallisey on 11/15/21.
//

import Foundation
import SwiftUI

//Create a UIHostingController class that hosts your SwiftUI view
class FAQviewcontroller: UIHostingController<ProfileSummary> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: ProfileSummary())
    }
}

struct ProfileSummary: View {
    var body: some View {
        //WILL IMPORT CHANGED LOGO IN THE BEGINNING FOR USER TO SEE
        ScrollView { // so the user can scroll
            VStack() { //could also put vstack to put it on top of it
                Text("1. What is this app for?") //bold title
                    .bold()
                    .font(.headline)
                    .foregroundColor(Color.blue)
                    .font(.system(size: 14, weight: .light, design: .serif))
                        .italic() //bold and italisize titles
                        .font(.title) //set font to a title
                        .padding() //for spacing
                Spacer()
                Text("The app is for patients breathing rehabilitation. It will provide you with a step by step tutorial of which how to properly complete your daily breathing. Additionally it will have information on all of the excersizes, a progress tracker, and more so that you have all the tools and resources to succeed on your journey of health.") //default is body
                Spacer()
                Text("2. How frequently should this app be used?") //bold title
                    .font(.headline)
                    .foregroundColor(Color.blue)
                    .bold()
                    .font(.system(size: 14, weight: .light, design: .serif))
                        .italic() //bold and italisize titles
                        .font(.title) //set font to a title
                    .padding()
                Spacer()
                Text("The frequency of this app is set by your doctor and you based on your physical therapy schedule.") //default is body
                Spacer()
                Text("3. What if I do not understand an excersize?") //bold title
                    .font(.headline)
                    .foregroundColor(Color.blue)
                    .bold()
                    .font(.system(size: 14, weight: .light, design: .serif))
                        .italic() //bold and italisize titles
                        .font(.title) //set font to a title
                    .padding()
                Text("The excersizes should be followed through a video after their description is shown. If confusion continues to arise contact your physical therapist and they will provide more answers on breathing technique.") //default is body
            }
            .padding()
        }
        //creating navigation view in the first file in the stack
    }
}

//struct ProfileSummary_Previews: PreviewProvider {
//    static var previews: some View {
//        FAQviewcontroller().previewLayout(.fixed(width: 896, height: 414))
//        ProfileSummary(profile: Profile.default)
//            .environmentObject(ModelData())
//    }
//}
