package com.opencode.service;

import com.opencode.controller.RegistrationForm;
import com.opencode.entity.Game;
import com.opencode.entity.Player;
import com.opencode.repository.GamesRepository;
import com.opencode.repository.PlayersRepository;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Optional;

@org.springframework.stereotype.Service
public class ServiceImpl implements Service{

    @Autowired PlayersRepository playersRepository;
    @Autowired GamesRepository   gamesRepository;

    @Override
    public Integer save( RegistrationForm form ){
        return playersRepository.saveAndFlush( new Player( form.getLogin() , form.getPassword() ) ).getId();
    }

    @Override
    public Optional<Player> loadEntity( String login , Boolean loadGames ){
        if( login == null ) return Optional.empty();
        return playersRepository.getByLogin( login ).map( player -> {
            if( loadGames ) player.setGames( playersRepository.getGamesByLogin( login ) );
            return player;
        } );
    }

    @Override
    public Optional<Game> getNewGameOrContinueOld( String login ){
//        todo Начать новую игру
        return gamesRepository.getNotEndedGameByPlayerLogin( login )
                              .map( id -> gamesRepository.findById( id ).orElse( null ) );
    }
}
