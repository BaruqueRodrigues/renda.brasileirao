
#' pega as estatitisticas dos times da serie a
#'
#' @param ano_campeonato ano do campeonato para retornar as estatisticas
#'
#' @return um dataframe as estatisticas dos times da serie 
#' @export
#' @import httr
#' @examples
pega_estatisticas <- function(ano_campeonato){
  
  df_id_time <-extrai_id_time(ano = ano_campeonato)
  
  executa_raspagem <-function(id_time){
    
    df_cod_ano<- data.frame(ano_camp = c(2008:2022),
                            cod = c(1223, 2079, 2684, 3311,
                                    4438, 6075, 7778, 10173,
                                    11429, 13100, 16183, 22931, 27591,
                                    36166, 40557))
    
    cod_campeonato <- df_cod_ano %>% 
      dplyr::filter(ano_camp == ano_campeonato) %>% 
      dplyr::pull(cod)
    
    
   
    url <-paste0("https://api.sofascore.com/api/v1/team/",
                 id_time ,
                 "/unique-tournament/325/season/",
                 cod_campeonato,
                 "/statistics/overall")
    
    payload <- ""
    
    encode <- "raw"
    
    response <-
      VERB(
        "GET",
        url,
        body = payload,
        add_headers(
          authority = 'api.sofascore.com',
          accept_language = 'pt-BR,pt;q=0.9',
          cache_control = 'max-age=0',
          origin = 'https://www.sofascore.com',
          referer = 'https://www.sofascore.com/',
          user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'
        ),
        content_type("application/octet-stream"),
        accept("*/*"),
        encode = encode
      )
    
    resposta <- content(response)
    
    
    df_resposta <- tibble::as_tibble_row(
      resposta$statistics,
      .name_repair = "minimal"
      
    )
    
    df_resposta %>% 
      janitor::clean_names() %>% 
      dplyr::mutate(id_time = id_time, .before = goals_scored)
  }
  
  df_stat <- purrr::map_dfr(df_id_time$id, executa_raspagem) %>% 
    dplyr::left_join(df_id_time) %>% 
    dplyr::relocate(nome_time, .before = goals_scored) %>% 
    dplyr::mutate(ano = ano_campeonato, .before = goals_scored)
  
  df_stat
}




