//
//  HomeView.swift
//  Task
//
//  Created by Chen Yue on 14/04/22.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var taskModel = TaskViewModel()
    @Namespace var animation
    
    var body: some   View {
//        NavigationView {
                  
            ScrollView(.vertical, showsIndicators: false) {
//                HeaderView()
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    Section {
    //                    HeaderView()
                        //MARK: Current Week View
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(taskModel.currentWeek, id: \.self) { day in
                                    VStack (spacing: 10) {
                                        Text(taskModel.extractDate(date: day, format: "dd"))
                                            .font(.system(size: 14))
                                            .fontWeight(.semibold)
                                        Text(taskModel.extractDate(date: day, format: "EEE"))
                                            .font(.system(size: 14))
                                        Circle()
                                            .fill(.white)
                                            .frame(width: 8, height: 8)
                                            .opacity(taskModel.isToday(date: day) ? 1 : 0)
                                    }
                                    .foregroundStyle(taskModel.isToday(date: day) ? .primary : .secondary)
                                    .foregroundColor(taskModel.isToday(date: day) ? .white : .black)
                                    //MARK: Capsule shape
                                    .frame(width: 45, height: 90)
                                    .background(
                                        ZStack {
                                            if taskModel.isToday(date: day) {
                                                Capsule()
                                                    .fill(.black)
                                                    .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                            }
                                        }
                                    )
                                    .contentShape(Capsule())
                                    .onTapGesture {
                                        withAnimation {
                                            taskModel.currentDay = day
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        Rectangle()
                            .fill(.gray)
                            .opacity(0.8)
                            .frame(height: 1)
                            .padding([.top, .leading, .trailing])
                        TasksView()
                    } header: {
                        HeaderView()
                    }
                }
            }
//            .padding(.top)
//            .ignoringSafeArea(.container, edges: .top)
            .ignoresSafeArea(.container, edges: .top)
            .navigationBarTitle("Task", displayMode: .inline)
//            .navigationBarHidden(true)
            
            .navigationViewStyle(StackNavigationViewStyle())
//            .statusBar(hidden: true)
//        }
////        .navigationBarHidden(true)
////        .navigationBarBackButtonHidden(true)
//        .navigationBarTitle("aaaa", displayMode: .inline)
//        .navigationViewStyle(StackNavigationViewStyle())
////        .statusBar(hidden: true)
       
    }
    
    //MARK: Task View
    func TasksView() -> some View {
        LazyVStack(spacing: 18) {
            if let tasks = taskModel.filteredTasks {
                if tasks.isEmpty {
                    Text("No tasks found!!!")
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .offset(y: 100)
                } else {
                    ForEach(tasks) { task in
                        TaskCardView(task: task)
                    }
                }
            } else {
                ProgressView()
                    .offset(y: 100)
            }
        }
        .padding()
        .padding(.top)
//        .onChange(of: taskModel.currentDay) { newValue in
//            taskModel.filterTodayTasks()
//        }
    }
    
    //MARK: Task Card View
    func TaskCardView(task: Task) -> some View {
        HStack(alignment: .top, spacing: 30) {
            VStack(spacing: 10) {
                Circle()
                    .fill(.black)
                    .frame(width: 15, height: 15)
                    .background {
                        Circle()
                            .stroke(.black, lineWidth: 1)
                            .padding(-3)
                    }
                Rectangle()
                    .fill(.black)
                    .frame(width: 3)
            }
            VStack {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(task.taskTitle)
                            .font(.title2.bold())
                        Text(task.taskDescription)
                            .font(.callout)
                    }
                    .hLeading()
                    Text(task.taskDate.formatted(date: .omitted, time: .shortened))
                }
                
            }
            .foregroundColor(.white)
            .padding()
            .hLeading()
            .background(
                Color.black.cornerRadius(25)
            )
        }
        .hLeading()
    }
    
    //MARK: Header
    func HeaderView() -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                Text("Today")
                    .font(.largeTitle.bold())
            }
            .hLeading()
            
            Button {
                
            } label: {
                Image("Profile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())
            }
        }
        .padding()
        .padding(.top, getSafeArea().top)
        .background(Color.white)
    }
    
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView()
    }
}


// Mark: UI DESGIN HELPER FUNCTION
extension View {
    
    func hLeading() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        guard let saftArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        return saftArea
    }
    
}
