package com.opencode.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.rememberme.JdbcTokenRepositoryImpl;
import org.springframework.security.web.authentication.rememberme.PersistentTokenRepository;
import org.springframework.security.web.csrf.CsrfTokenRepository;
import org.springframework.security.web.csrf.HttpSessionCsrfTokenRepository;

import javax.sql.DataSource;
import java.time.Duration;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter{

    @Autowired DataSource         dataSource;
    @Autowired UserDetailsService userDetailsService;

    @Autowired
    public void configureGlobalSecurity( AuthenticationManagerBuilder auth ) throws Exception{
        auth.userDetailsService( userDetailsService );
        auth.authenticationProvider( authenticationProvider() );
    }

    @Bean
    public PasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder( 5 );
    }

    @Bean
    public DaoAuthenticationProvider authenticationProvider(){
        DaoAuthenticationProvider authenticationProvider = new DaoAuthenticationProvider();
        authenticationProvider.setUserDetailsService( userDetailsService );
        authenticationProvider.setPasswordEncoder( passwordEncoder() );
        return authenticationProvider;
    }

    @Override
    protected void configure( HttpSecurity http ) throws Exception{
        http.authorizeRequests()
            .antMatchers( "/" , "/home" , "/resources/**" , "/registration" , "/rating" )
            .permitAll()
            .anyRequest()
            .authenticated()

            .and()
            .formLogin()
            .loginPage( "/login" )
            .usernameParameter( "login" )
            .passwordParameter( "pass" )
            .defaultSuccessUrl( "/person" )

            .and()
            .logout()
            .logoutUrl( "/logout" )
            .deleteCookies( "JSESSIONID" )

            .and()
            .rememberMe()

            .tokenRepository( persistentTokenRepository() )
            .userDetailsService( userDetailsService )
            .tokenValiditySeconds( ( int ) Duration.ofDays( 1 ).toMillis() )

            .and()
            .csrf()
            .csrfTokenRepository( csrfTokenRepository() );
    }

    @Bean
    public CsrfTokenRepository csrfTokenRepository(){
        HttpSessionCsrfTokenRepository repository = new HttpSessionCsrfTokenRepository();
        repository.setSessionAttributeName( "_csrf" );
        return repository;
    }

    @Bean
    public PersistentTokenRepository persistentTokenRepository(){
        JdbcTokenRepositoryImpl tokenRepositoryImpl = new JdbcTokenRepositoryImpl();
        tokenRepositoryImpl.setDataSource( dataSource );
        return tokenRepositoryImpl;
    }
}
