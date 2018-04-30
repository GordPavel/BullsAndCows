package com.opencode.service;

import com.opencode.controller.RegistrationForm;
import com.opencode.entity.Game;
import com.opencode.entity.Player;

import java.util.Optional;

public interface Service{
    Integer save( RegistrationForm form );

    Optional<Player> loadEntity( String login , Boolean loadGames );

    Optional<Game> getNewGameOrContinueOld( String login );
}
