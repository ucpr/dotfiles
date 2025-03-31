FROM denoland/deno:2.2.6

WORKDIR config

COPY . .

CMD ["bash"]
