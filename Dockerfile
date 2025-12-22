FROM denoland/deno:2.6.3

WORKDIR config

COPY . .

CMD ["bash"]
