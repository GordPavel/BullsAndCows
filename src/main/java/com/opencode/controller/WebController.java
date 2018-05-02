package com.opencode.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.opencode.entity.Attempt;
import com.opencode.entity.Game;
import com.opencode.repository.AttemptsRepository;
import com.opencode.repository.GamesRepository;
import com.opencode.repository.PlayersRepository;
import com.opencode.service.Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
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

import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.*;


@Controller
public class WebController{

    @Autowired PlayersRepository  playersRepository;
    @Autowired GamesRepository    gamesRepository;
    @Autowired AttemptsRepository attemptsRepository;

    @Autowired PasswordEncoder passwordEncoder;
    @Autowired Service         service;

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

    @Bean
    ObjectMapper objectMapper(){
        return new ObjectMapper();
    }

    @GetMapping( value = { "/" , "/login" } )
    String login( Model model ){
        model.addAttribute( "registrationForm" , new RegistrationForm() );
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
        return "login";
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

    @PostMapping( value = "/newAttempt", consumes = "text/plain" )
    @ResponseBody
    ResponseEntity<?> newAttempt(
            @RequestBody
                    String body ) throws IOException{
        try{
            final Map<String, String>
                    requestBody =
                    objectMapper().readValue( body , new TypeReference<Map<String, String>>(){ } );
            final String
                    login =
                    ( ( User ) SecurityContextHolder.getContext().getAuthentication().getPrincipal() ).getUsername();
            final Integer gameId        = Integer.parseInt( requestBody.get( "gameId" ) );
            final String  attemptNumber = requestBody.get( "attempt" );
            if( !attemptNumber.matches( "^\\d{4}$" ) ) throw new NumberFormatException( "Illegal attempt string" );
            final Game
                    game =
                    gamesRepository.findById( gameId )
                                   .orElseThrow( () -> new IllegalArgumentException( "Illegal game's id" ) );
//            Check player's nickname
            playersRepository.getByLogin( login )
                             .filter( game.getPlayer()::equals )
                             .orElseThrow( () -> new IllegalArgumentException( "Illegal player's nickname" ) );
//            Check if game finished
            if( game.getAttempts()
                    .parallelStream()
                    .max( Comparator.comparingInt( Attempt::getId ) )
                    .map( attempt -> game.getGuessedNumber().equals( attempt.getNumber() ) )
                    .orElse( false ) ) throw new IllegalArgumentException( "This game is already finished" );
            Attempt attempt = new Attempt();
            attempt.setGame( game );
            attempt.setNumber( attemptNumber );
            attemptsRepository.saveAndFlush( attempt );
            if( attemptNumber.equals( game.getGuessedNumber() ) )
                return ResponseEntity.ok().headers( new HttpHeaders(){{
                    add( "Content-Type" , "text/plain; charset=utf-8" );
                }} ).body( "Ты победил!" );
            else{
                Integer bulls = 0;
                Integer cows  = 0;
                final Iterator<String>
                        guessedNumberIterator =
                        Arrays.stream( game.getGuessedNumber().split( "" ) ).iterator();
                for( String symbol : attemptNumber.split( "" ) ){
                    if( symbol.equals( guessedNumberIterator.next() ) ) bulls++;
                    else if( game.getGuessedNumber().contains( symbol ) ) cows++;
                }
                return ResponseEntity.ok().headers( new HttpHeaders(){{
                    add( "Content-Type" , "text/plain; charset=utf-8" );
                }} ).body( String.format( "%dБ%dК" , bulls , cows ) );
            }
        }catch( IllegalArgumentException e ){
            return ResponseEntity.badRequest().body( e.getMessage() );
        }
    }

    @GetMapping( value = "/rating" )
    String rating( Model model ){
        model.addAttribute( "rating" , service.rating() );
        return "rating";
    }
}
