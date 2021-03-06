package com.opencode.config;

import com.opencode.entity.Player;
import com.opencode.repository.PlayersRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.Optional;

@Service
public class CustomUserDetails implements UserDetailsService{

    @Autowired PlayersRepository repository;

    @Transactional( readOnly = true )
    @Override
    public UserDetails loadUserByUsername( String login ) throws UsernameNotFoundException{
        final Optional<Player> byLogin = repository.getByLogin( login );
        Player player = byLogin.orElseThrow( () -> new UsernameNotFoundException( "Username not found" ) );
        return new User( player.getLogin() ,
                         player.getPass() ,
                         true ,
                         true ,
                         true ,
                         true ,
                         Collections.singleton( new SimpleGrantedAuthority( "ROLE_USER" ) ) );
    }
}
