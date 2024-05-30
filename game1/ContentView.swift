//
//  ContentView.swift
//  game1
//
//  Created by Jigar on 30/05/24.
//


import SwiftUI

struct NeonButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(Color.white.opacity(0.7))
            .background(
                ZStack {
                    configuration.isPressed ? Color.blue.opacity(0.5) : Color.clear
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2)
                        .blur(radius: 4)
                        .offset(x: 2, y: 2)
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2)
                        .blur(radius: 4)
                        .offset(x: -2, y: -2)
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue.opacity(0.8), lineWidth: 2)
                        .blur(radius: 2)
                        .offset(x: 0, y: 0)
                }
            )
    }
}

struct ContentView: View {
    @State private var platformPosition: CGFloat = 0
    @State private var blockPosition: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: -50)
    @State private var timer: Timer?
    @State private var score: Int = 0

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Retro-style score display
                Text("Score: \(score)")
                    .font(.largeTitle)
                    .foregroundColor(.yellow)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
                    .shadow(color: .yellow, radius: 10, x: 0, y: 0)
                    .padding(.top, 20)

                Spacer()

                // Falling Block
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 30, height: 30)
                    .position(blockPosition)
                    .animation(.linear(duration: 0.05))

                Spacer()

                // Movable Platform
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 100, height: 20)
                    .position(x: UIScreen.main.bounds.width / 2 + platformPosition, y: UIScreen.main.bounds.height - 100)

                Spacer()

                // Virtual Gamepad
                HStack {
                    // Directional Buttons
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: { movePlatformUp() }) {
                                Image(systemName: "triangle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.blue)
                                    .opacity(0.5)
                                    .buttonStyle(NeonButtonStyle())
                            }
                            Spacer()
                        }
                        .padding(.bottom, 40) // Increased spacing
                        
                        HStack {
                            Button(action: { movePlatformLeft() }) {
                                Image(systemName: "triangle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .rotationEffect(.degrees(-90))
                                    .foregroundColor(.blue)
                                    .opacity(0.5)
                                    .buttonStyle(NeonButtonStyle())
                            }
                            .padding(.trailing, 40) // Increased spacing
                            Spacer()
                            Button(action: { movePlatformRight() }) {
                                Image(systemName: "triangle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .rotationEffect(.degrees(90))
                                    .foregroundColor(.blue)
                                    .opacity(0.5)
                                    .buttonStyle(NeonButtonStyle())
                            }
                            .padding(.leading, 40) // Increased spacing
                        }
                        .padding(.horizontal, 40)
                        
                        HStack {
                            Spacer()
                            Button(action: { movePlatformDown() }) {
                                Image(systemName: "triangle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .rotationEffect(.degrees(180))
                                    .foregroundColor(.blue)
                                    .opacity(0.5)
                                    .buttonStyle(NeonButtonStyle())
                            }
                            Spacer()
                        }
                        .padding(.top, 40) // Increased spacing
                    }
                    .padding(.leading, 10)

                    Spacer()

                    // Action Buttons
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: { jumpAction() }) {
                                Image(systemName: "a.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.green)
                                    .opacity(0.5)
                                    .buttonStyle(NeonButtonStyle())
                            }
                            Spacer()
                        }
                        .padding(.bottom, 40) // Increased spacing
                        
                        HStack {
                            Button(action: { shootAction() }) {
                                Image(systemName: "b.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.green)
                                    .opacity(0.5)
                                    .buttonStyle(NeonButtonStyle())
                            }
                            .padding(.trailing, 40) // Increased spacing
                            Spacer()
                            Button(action: { fastShootAction() }) {
                                Image(systemName: "c.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.orange)
                                    .opacity(0.5)
                                    .buttonStyle(NeonButtonStyle())
                            }
                            .padding(.leading, 40) // Increased spacing
                        }
                        .padding(.horizontal, 40)
                        
                        HStack {
                            Spacer()
                            Button(action: { highJumpAction() }) {
                                Image(systemName: "d.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.orange)
                                    .opacity(0.5)
                                    .buttonStyle(NeonButtonStyle())
                            }
                            Spacer()
                        }
                        .padding(.top, 40) // Increased spacing
                    }
                    .padding(.trailing, 10)
                }
                .padding(.bottom, 50)

                Spacer()

                // Select and Start Buttons
                HStack(spacing: 40) {
                    Button(action: { selectAction() }) {
                        Text("Select")
                            .frame(width: 80, height: 40)
                            .background(Color.gray.opacity(0.7))
                            .cornerRadius(20)
                            .foregroundColor(.white)
                    }
                    Button(action: { startAction() }) {
                        Text("Start")
                            .frame(width: 80, height: 40)
                            .background(Color.gray.opacity(0.7))
                            .cornerRadius(20)
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            startGame()
        }
    }

    func startGame() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            updateGame()
        }
    }

    func updateGame() {
        // Move the block down
        blockPosition.y += 5

        // Check if the block hits the bottom
        if blockPosition.y > UIScreen.main.bounds.height {
            resetBlock()
        }

        // Check if the block is caught by the platform
        if blockPosition.y > UIScreen.main.bounds.height - 70 &&
            abs(blockPosition.x - (UIScreen.main.bounds.width / 2 + platformPosition)) < 50 {
            score += 1
            resetBlock()
        }
    }

    func resetBlock() {
        blockPosition = CGPoint(x: CGFloat.random(in: 0...UIScreen.main.bounds.width), y: -50)
    }

    func movePlatformLeft() {
        platformPosition -= 20
    }

    func movePlatformRight() {
        platformPosition += 20
    }

    func movePlatformUp() {
        // Add code to handle moving up if needed
    }

    func movePlatformDown() {
        // Add code to handle moving down if needed
    }

    func selectAction() {
        // Add code for select action
    }

    func startAction() {
        // Add code for start action
    }

    func jumpAction() {
        // Add code for jump action
    }

    func shootAction() {
        // Add code for shoot action
    }

    func fastShootAction() {
        // Add code for fast shoot action
    }

    func highJumpAction() {
        // Add code for high jump action
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

