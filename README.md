# Movie Finder
A sample that allows to search for a movie and see si milar movies.

It's a very basic app (with a VERY basic UI) that relies on querying a REST API and display the results.
Here I mostly focused on a very classic MVVM-C pattern using RxSwift. 
Not gonna lie, I usually favor good old delegates and completion blocks (I made more or less the same app without RxSwift [here](https://github.com/mloigeret/MovieSearch). For a change here, I tried to knock everything I could with a RxSwift hammer.
Nothing revolutionary but just keeping this as a reference as sometimes I find myself working on RxSwift projects.


IMPORTANT: You have to use your own TMDB api key. Create it at [TMDB](https://www.themoviedb.org/). Once you have one set it in MovieSearch/Configuration/ApiKeys.swift
