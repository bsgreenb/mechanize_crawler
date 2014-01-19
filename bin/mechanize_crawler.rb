#TODO: TDD
#TODO: start by writing out the behavior of a single page to work, then get the crawler rolling


#We'd like you to write a web crawler in a modern language (ruby, python, coffeescript etc). It should be limited to one domain - so when crawling joingrouper.com it would crawl all pages within the joingrouper.com domain, but not follow the links to our Facebook and Instagram accounts. Given a URL, it should output a site map, showing which static assets each page depends on, and the links between pages. Choose the most appropriate data structure to store & display this site map.
#
#Build this as you would something for production. Focus on code quality and write tests as appropriate. Spend a few hours on it, then send me a link and we can figure out a time to talk about it.


@crawled = {}
