package com.opencode.service;

import com.opencode.controller.RegistrationForm;
import com.opencode.entity.Player;

import java.util.Optional;

public interface PlayersService{
    Integer save( RegistrationForm form );

    Optional<Player> loadEntity( String login , Boolean loadGames );
}
