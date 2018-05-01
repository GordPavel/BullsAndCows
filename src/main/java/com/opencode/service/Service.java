package com.opencode.service;

import com.opencode.controller.RegistrationForm;
import com.opencode.entity.Game;
import com.opencode.entity.Player;
import com.opencode.repository.GamesRepository;
import com.opencode.repository.PlayersRepository;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Optional;
import java.util.Random;
import java.util.stream.Collectors;

@org.springframework.stereotype.Service
public class Service{

    @Autowired PlayersRepository playersRepository;
    @Autowired GamesRepository   gamesRepository;

    public Integer save( RegistrationForm form ){
        return playersRepository.saveAndFlush( new Player( form.getLogin() , form.getPassword() ) ).getId();
    }

    public Optional<Player> loadPlayer( String login , Boolean loadGames ){
        if( login == null ) return Optional.empty();
        return playersRepository.getByLogin( login ).map( player -> {
            if( loadGames ) player.setGames( playersRepository.getGamesByLogin( login ) );
            return player;
        } );
    }

    public Game newGame( String player ){
        Game game = new Game();
//        todo Обработка ошибок
        game.setPlayer( playersRepository.getByLogin( player ).orElseThrow( IllegalStateException::new ) );
        game.setGuessedNumber( new Random( System.currentTimeMillis() ).ints( 0 , 9 )
                                                                       .distinct()
                                                                       .limit( 4 )
                                                                       .boxed()
                                                                       .map( String::valueOf )
                                                                       .collect( Collectors.joining( "" ) ) );
        return gamesRepository.saveAndFlush( game );
    }
}
