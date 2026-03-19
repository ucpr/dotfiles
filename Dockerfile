FROM denoland/deno:2.7.6

WORKDIR config

COPY . .

CMD ["bash"]
