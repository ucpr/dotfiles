FROM denoland/deno:2.5.3

WORKDIR config

COPY . .

CMD ["bash"]
