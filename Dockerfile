FROM denoland/deno:1.42.4

WORKDIR config

COPY . .

CMD ["bash"]
