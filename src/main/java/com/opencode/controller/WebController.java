package com.opencode.controller;

import com.opencode.entity.Game;
import com.opencode.repository.GamesRepository;
import com.opencode.repository.PlayersRepository;
import com.opencode.service.Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;
import org.springframework.web.bind.annotation.*;

import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.LinkedList;
import java.util.Optional;


@Controller
public class WebController{

    @Autowired PasswordEncoder   passwordEncoder;
    @Autowired PlayersRepository playersRepository;
    @Autowired GamesRepository   gamesRepository;
    @Autowired Service           service;

    @Bean
    Validator getRegistrationValidator(){
        return new Validator(){
            @Override
            public boolean supports( Class<?> aClass ){
                return RegistrationForm.class.equals( aClass );
            }

            @Override
            public void validate( Object o , Errors errors ){
                ValidationUtils.rejectIfEmptyOrWhitespace( errors , "login" , "" , "Couldn't be empty" );
                ValidationUtils.rejectIfEmptyOrWhitespace( errors , "password" , "" , "Couldn't be empty" );
                ValidationUtils.rejectIfEmptyOrWhitespace( errors , "passwordConfirm" , "" , "Couldn't be empty" );

                if( playersRepository.getByLogin( ( ( RegistrationForm ) o ).getLogin() ).isPresent() )
                    errors.rejectValue( "login" , "" , "Nickname already exists" );
            }
        };
    }

    @ModelAttribute( "registrationForm" )
    RegistrationForm registrationForm(){
        return new RegistrationForm();
    }

    @GetMapping( value = { "/" , "/login" } )
    String login(
            @RequestParam( required = false )
                    String logout , Model model ){
        final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if( authentication.getPrincipal() instanceof User ){
            final String login = ( ( User ) authentication.getPrincipal() ).getUsername();
            return "redirect:/person/" + login;
        }
        if( logout != null ) model.addAttribute( "logout" , "You have been logged out successfully." );
        return "login";
    }

    @GetMapping( value = "/person/{login}" )
    String personPage(
            @PathVariable
                    String login , Model model ){
//        todo Если пользователь не найден
        model.addAttribute( "user" , service.loadPlayer( login , true ).get() );
        model.addAttribute( "formatter" , DateTimeFormatter.ofPattern( "dd.MM.yyyy HH:mm" ) );
        return "playerPage";
    }

    @PostMapping( value = "/registration" )
    String registration(
            @ModelAttribute( "registrationForm" )
                    RegistrationForm form , BindingResult bindingResult , Model model ){
        getRegistrationValidator().validate( form , bindingResult );
        if( bindingResult.hasErrors() ) return "login";
        form.setPassword( passwordEncoder.encode( form.getPassword() ) );
        service.save( form );
        model.addAttribute( "registrationSuccess" , "Registration success" );
        return login( null , model );
    }


    @GetMapping( value = "/game/{id}" )
    String gameById(
            @PathVariable
                    Integer id , Model model ){
        final String
                login =
                ( ( User ) SecurityContextHolder.getContext().getAuthentication().getPrincipal() ).getUsername();
        final LinkedList<Game>
                notEndedGamesOfPrincipal =
                new LinkedList<>( gamesRepository.getNotEndedGamesByPlayerLogin( login ) );
        Game                 game;
        final Optional<Game> optionalGame = gamesRepository.findById( id ).filter( notEndedGamesOfPrincipal::contains );
        if( optionalGame.isPresent() ){
            game = optionalGame.get();
            notEndedGamesOfPrincipal.remove( game );
        }else{
            game = service.newGame( login );
            game.setAttempts( Collections.emptyList() );
            model.addAttribute( "error" , "Error while finding specified game" );
        }
        model.addAttribute( "game" , game );
        model.addAttribute( "list" , notEndedGamesOfPrincipal );
        return "game";
    }

    @GetMapping( value = "/game" )
    String game( Model model ){
        final String
                login =
                ( ( User ) SecurityContextHolder.getContext().getAuthentication().getPrincipal() ).getUsername();
        final LinkedList<Game>
                notEndedGamesOfPrincipal =
                new LinkedList<>( gamesRepository.getNotEndedGamesByPlayerLogin( login ) );
        final Optional<Game> optionalGame = Optional.ofNullable( notEndedGamesOfPrincipal.pollFirst() );
        Game                 game         = optionalGame.orElseGet( () -> service.newGame( login ) );
        model.addAttribute( "game" , game );
        model.addAttribute( "list" , notEndedGamesOfPrincipal );
        return "game";
    }

    @GetMapping( value = "rating" )
    String rating( Model model ){
        return "rating";
    }
}
