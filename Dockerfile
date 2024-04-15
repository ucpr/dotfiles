FROM denoland/deno:1.42.3

WORKDIR config

COPY . .

CMD ["bash"]
