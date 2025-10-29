FROM denoland/deno:2.5.5

WORKDIR config

COPY . .

CMD ["bash"]
