

#' extrai id dos times da serie A
#'
#' @param ano do campeonato
#'
#' @return um dataframe com os ids dos times da serie A
#' 
#' @import httr
#' @examples
extrai_id_time<- function(ano){
  
  df_cod_ano<- data.frame(ano_campeonato = c(2008:2022),
                          cod = c(1223, 2079, 2684, 3311,
                                  4438, 6075, 7778, 10173,
                                  11429, 13100, 16183, 22931, 27591,
                                  36166, 40557))
  
  cod_campeonato <- df_cod_ano %>% 
    dplyr::filter(ano_campeonato == ano) %>% 
    dplyr::pull(cod)
  
  
  url <-  paste0(
    "https://api.sofascore.com/api/v1/unique-tournament/325/season/",
    cod_campeonato,
    "/standings/total")
  
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
        user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'
      ),
      content_type("application/octet-stream"),
      accept("*/*"),
      encode = encode
    )
  
  cnt <- content(response, simplifyDataFrame = TRUE)
  
  df_resposta <-cnt$standings %>%
    dplyr::tibble() %>%
    dplyr::pull(rows) %>%
    purrr::pluck(1) %>% 
    dplyr::tibble() %>%
    dplyr::pull(team) %>% 
    dplyr::select(nome_time ="name",id_time = "id")
  
  df_resposta
}

