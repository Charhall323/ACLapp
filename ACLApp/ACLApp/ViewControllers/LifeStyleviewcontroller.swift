////
////  LifeStyleviewcontroller.swift
////  ACLApp
////
////
//
//import Foundation
//import SwiftUI
//
////had some trouble adding phtoos between every single question to make it appealing with the user, will be looking more into that - code did not like it when I had multiple labels and said I had too many arguments but did not know how to fix
//
//struct Lifestyle: View {
//    var body: some View {
//        ScrollView {
//            VStack {
//                Text("LifeStyle")
//                    .foregroundColor(Color.blue)
//                    .bold()
//                    .font(.title)
//                    .padding()
//                
//                Text("Drink Water")
//                    .font(.body)
//                    .fontWeight(.bold)
//                    .multilineTextAlignment(.leading)
//                Text("It is critical for overall health as well as breathing functions that every individual drinks at least 8 cups of water a day! Reasons to support this include redness, dullness, dehydration of the skin and/or acne.")
//                    .padding(20.0)
//                
//                Text("Avoid Irritants")
//                    .font(.body)
//                    .fontWeight(.bold)
//                    .multilineTextAlignment(.leading)
//                Text("Be mindful of the weather outside. Hot weather can cause symptoms to flare up, especially when the patient becomes dehydrated.")
//                    .padding(20.0)
//                
//                
//                Text("Avoid Dairy")
//                    .font(.body)
//                    .fontWeight(.bold)
//                    .multilineTextAlignment(.leading)
//                Text("Contrary to popular belief dairy is not critical for bone health and can cause further issues to sensitivities. A dairy allergy can worsen breathing, stomach and skin reachtions")
//                    .padding(20.0)
//                
//                Text("Sleep is Important")
//                    .font(.body)
//                    .fontWeight(.bold)
//                    .multilineTextAlignment(.leading)
//                Text("Sleep is essential in recovery. In order to heal patients must be getting the recommended 9 hours of sleep a day.")
//                    .padding(20.0)
//            }.padding(10.0)
//        }
//    }
//}
//
//struct Lifestyle_Previews: PreviewProvider {
//    static var previews: some View {
//        Lifestyle()
//    }
//}
//
//
//        
//        
//        
//        
////        Menu {
////            Text("Lifestyle Reminders!")
////                .fontWeight(.semibold)
////                .foregroundColor(Color.green)
////            Button(action: {
////            }, label: {
////                HStack {
////                    Text("Trash")
////                }
////            })
////        } label: {
////            Label(
////                title: { Text("Options")},
////                )
////        }
////
//        
//        
//    
//        
//        
////        VStack {
////            Text("Lifestyle Reminders!")
////                .fontWeight(.semibold)
////                .foregroundColor(Color.green)
////            Button(action: {
////                print("It is critical for overall health as well as breathing functions that every individual drinks at least 8 cups of water a day! Reasons to support this include redness, dullness, dehydration of the skin and/or acne")
////            }) {
////                Text("Drink Water!")
////            }
////            spacer()
////            Button(action: {
////                print("Be mindful of the weather outside. Hot weather can cause symptoms to flare up, especially when the patient becomes dehydrated")
////            }) {
////                Text("Avoid Irritants")
////            }
////            spacer()
////            Button(action: {
////                print("Contrary to popular belief dairy is not critical for bone health and can cause further issues to sensitivities. A dairy allergy can worsen breathing, stomach and skin reachtions")
////            }) {
////                Text("Avoid Dairy")
////            }
////            spacer()
////            Button(action: {
////                print("Sleep is essential in recovery":"In order to heal patients must be getting the recommended 9 hours of sleep a day.")
////            }) {
////                Text("Sleep is Critical")
////            }
////        }
////    }
////}
////
//
//struct Lifestyle_Previews: PreviewProvider {
//    static var previews: some View {
//        Lifestyle()
//        }
//}
