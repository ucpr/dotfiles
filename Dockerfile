FROM denoland/deno:2.1.5

WORKDIR config

COPY . .

CMD ["bash"]
