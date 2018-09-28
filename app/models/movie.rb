class Movie < ActiveRecord::Base
    def self.all_ratings
        each_rating = []
        Movie.all.each do |movie|
            if(each_rating.find_index(movie.rating) == nil)
                each_rating.push(movie.rating)
            end
        end
        
        return each_rating
    end
end
