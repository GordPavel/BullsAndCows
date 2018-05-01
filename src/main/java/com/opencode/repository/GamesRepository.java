package com.opencode.repository;

import com.opencode.entity.Game;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.util.List;

@SuppressWarnings( "SpringDataRepositoryMethodReturnTypeInspection" )
@Repository
public interface GamesRepository extends JpaRepository<Game, Integer>{


    /**
     Lists all unfinished games of specified player. Finished game – if it's last attempt is equal guessed number of
     this game.

     @param login nickname of player

     @return list of unfinished games
     */
    @Query( value = "select" +
                    "  game.id," +
                    "  game.date_of_game," +
                    "  game.player," +
                    "  game.guessed_number " +
                    "from public.game as game" +
                    "  join (select" +
                    "          game," +
                    "          max(id) as at" +
                    "        from public.attempt" +
                    "        group by game) mid on game.id = mid.game " +
                    "where game.guessed_number != (select number" +
                    "                              from public.attempt" +
                    "                              where id = mid.at) and player = (select id" +
                    "                                                               from public.player" +
                    "                                                               where login =:login) " +
                    "order by game.date_of_game desc;", nativeQuery = true )
    List<Game> getNotEndedGamesByPlayerLogin(
            @Param( "login" )
                    String login );

    /**
     Rating is counted just by finished games. Finished game – if it's last attempt is equal guessed number of
     this game.

     @return sorted by average attempts for each player list with his id and login
     */
    @Query( value = "select" +
                    "  p.id," +
                    "  p.login," +
                    "  av.avg " +
                    "from player p" +
                    "  join" +
                    "  (select" +
                    "     player," +
                    "     avg(c.count) as avg" +
                    "   from game g" +
                    "     join (select" +
                    "             ended.id," +
                    "             count(attempt.id) as count" +
                    "           from (select id" +
                    "                 from game" +
                    "                   join (select" +
                    "                           game," +
                    "                           max(id) as at" +
                    "                         from public.attempt" +
                    "                         group by game) mid on game.id = mid.game" +
                    "                 where game.guessed_number = (select number" +
                    "                                              from attempt" +
                    "                                              where id = mid.at)) ended" +
                    "             join attempt on ended.id = attempt.game" +
                    "           group by ended.id) c on g.id = c.id" +
                    "   group by player) av on p.id = av.player order by av.avg;", nativeQuery = true )
    List<ResultSet> rating();
}
