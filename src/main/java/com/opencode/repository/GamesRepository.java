package com.opencode.repository;

import com.opencode.entity.Game;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface GamesRepository extends JpaRepository<Game, Integer>{
    @Query( value = "select id\n" +
                    "from public.game\n" +
                    "  join (select\n" +
                    "          game,\n" +
                    "          max(id) as at\n" +
                    "        from public.attempt\n" +
                    "        group by game) mid on game.id = mid.game\n" +
                    "where guessed_number != (select number\n" +
                    "                         from public.attempt\n" +
                    "                         where id = mid.at) and player = (select id\n" +
                    "                                                          from public.player\n" +
                    "                                                          where login =:login);",
            nativeQuery = true )
    Optional<Integer> getNotEndedGameByPlayerLogin(
            @Param( "login" )
                    String login );
}
