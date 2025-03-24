FROM denoland/deno:2.2.5

WORKDIR config

COPY . .

CMD ["bash"]
