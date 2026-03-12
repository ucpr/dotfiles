FROM denoland/deno:2.7.5

WORKDIR config

COPY . .

CMD ["bash"]
