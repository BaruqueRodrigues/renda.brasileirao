#' baixa_rendas_brasileirao_d
#'
#' @param n_rodadas vetor com número de rodadas
#'
#' @return dataframe com os dados sobre o financiamento das partidas da série C do brasileirão
#' @export
#' @import httr
#' @examples
#' baixa_rendas_brasileirao_d(1:15)
baixa_rendas_brasileirao_d <- function(n_rodadas){
  
  executa_download <- function(n_rodadas){
    
    rodadas <- n_rodadas
    
    url <- "https://www.srgoool.com.br/call"
    
    queryString <- list('ajax' = "get_ranking2")
    
    payload <- paste0("id_fase=3114&rodada=",
                      rodadas,
                      "&=&sort=")
    
    encode <- "form"
    
    response <-
      VERB(
        "POST",
        url,
        body = payload,
        add_headers(
          authority = 'www.srgoool.com.br',
          accept_language = 'pt-BR,pt;q=0.9',
          origin = 'https://www.srgoool.com.br',
          referer = 'https://www.srgoool.com.br/classificacao/Brasileirao/Serie-D/2022',
          user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'),
        query = queryString,
        content_type("application/x-www-form-urlencoded"),
        accept("application/json, text/javascript, */*; q=0.01"),
        set_cookies(`CookiePlacarFixo` = "1,43"),
        encode = encode
      )
    
    conteudo <-content(response, simplifyDataFrame = TRUE)
    
    df_rendas <- conteudo$list 
  }
  
  n_rodadas <- n_rodadas
  
  dados <- n_rodadas %>% 
    purrr::map_dfr(executa_download, .id = "rodadas") %>% 
    tibble::tibble()
  
  dados 
}

baixa_rendas_brasileirao_d(1) %>% View()

