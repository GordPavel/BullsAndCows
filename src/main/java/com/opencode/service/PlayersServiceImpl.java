package com.opencode.service;

import com.opencode.controller.RegistrationForm;
import com.opencode.entity.Player;
import com.opencode.repository.PlayersRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class PlayersServiceImpl implements PlayersService{

    @Autowired PlayersRepository playersRepository;

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
}
