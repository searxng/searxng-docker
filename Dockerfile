#This is a sample Image
FROM searxng/searxng

# Replace the existing theme
COPY searxng.png /usr/local/searxng/searx/static/themes/simple/img/

# Amend the ownership of the new image
RUN chown searxng:searxng /usr/local/searxng/searx/static/themes/simple/img/searxng.png
