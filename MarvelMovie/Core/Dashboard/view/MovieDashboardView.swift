//
//  MovieDashboardView.swift
//  MarvelMovie
//
//  Created by Eranga Prabath on 2024-08-31.
//

import SwiftUI

struct MovieDashboardView: View {
    @State private var currentIndex:Int? = 0
    @State private var dashboardViewModel = DashboardViewModel()
    @State private var movieData:[FilmCardDataModel] = []
    @State private var tvSeriesData:[FilmCardDataModel] = []
    private let placeHolderData:MoviePlaceholder = MoviePlaceholder()
    @State private var test:Bool = false
    let columns = [
            GridItem(.flexible()), // First column
            GridItem(.flexible())  // Second column
        ]
    var body: some View {
        VStack(alignment: .leading){
          ProfileSection()
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
            MovieGenreView()
            List{
                movieSection
                tvSerSection
            }.scrollIndicators(.never)
                .listStyle(.plain)
               
            
        }.background(Color.black.opacity(0.98)
            .ignoresSafeArea())
        .navigationDestination(isPresented: $test) {
            EmptyView()
        }
       
    }
}
extension MovieDashboardView{
    private var movieSection:some View{
            VStack{
                ScrollView(.horizontal){
                    LazyHStack(){
                        ForEach(movieData,id:\.id){ singleMovie in
                            FilmCardView(singleMovie:singleMovie)
                                .redacted(reason: !dashboardViewModel.viewIsLoaded ? .placeholder :.privacy)
                                .onTapGesture {
                                    test = true
                                }.onAppear(perform: {
                                    if singleMovie.id == dashboardViewModel.movieDataSet.last?.id{
                                        dashboardViewModel.loadMoreData(isMovie: true)
                                    }
                                })
                        }
                    }
                }.scrollTargetBehavior(.viewAligned)
                .scrollTargetLayout()
                .scrollClipDisabled()
            } .onReceive(dashboardViewModel.$movieDataSet, perform: { newValues in
                self.movieData = newValues
            })
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
    private var tvSerSection:some View{
            VStack{
                ScrollView(.horizontal){
                    LazyHStack{
                        ForEach(tvSeriesData,id:\.id){ singleMovie in
                            FilmCardView(singleMovie:singleMovie)
                                .redacted(reason: !dashboardViewModel.viewIsLoaded ? .placeholder :.privacy)
                                .onTapGesture {
                                    test = true
                                }.onAppear(perform: {
                                    if singleMovie.id == dashboardViewModel.tvSeriesDataSet.last?.id{
                                        dashboardViewModel.loadMoreData(isMovie: false)
                                    }
                                })
                        }
                    }
                }.scrollTargetBehavior(.viewAligned)
                .scrollTargetLayout()
                .scrollClipDisabled()
            } .onReceive(dashboardViewModel.$tvSeriesDataSet, perform: { newValues in
                self.tvSeriesData = newValues
            })
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
}
#Preview {
    MovieDashboardView()
}


